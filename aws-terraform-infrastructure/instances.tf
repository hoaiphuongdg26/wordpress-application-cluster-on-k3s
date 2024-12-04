# aws-terraform-infrastructure/instances.tf
# Get Ubuntu 20.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

locals {
  ec2_ami = var.ami != "" ? var.ami : data.aws_ami.ubuntu.id
}

# Create Management Server (Bastion Host/Jenkins/HAProxy)
resource "aws_instance" "management_server" {
  count         = var.aws_instance_config.management_instance_count
  ami           = local.ec2_ami
  instance_type = var.aws_instance_config.management_instance_type
  private_ip    = var.aws_instance_config.management_private_ips[count.index]

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.management_sg.id]
  key_name               = module.keypair.key_name
  tags = {
    Name = "${var.aws_project}-management-server-${count.index}"
  }
  associate_public_ip_address = true
}

module "eip-management_server" {
  source = "./modules/eip"
  depends_on = [aws_instance.management_server]
  name             = "${var.aws_project}-app"
  instance_ids     = aws_instance.management_server.*.id
  internet_gateway = module.vpc.internet_gateway_id
  create_eip       = true
}

# Create Kubernetes Master Node (Master Node/NFS Server/Monitoring Stack (Prometheus/Grafana))
resource "aws_instance" "k8s_masters" {
  count         = var.aws_instance_config.k8s_master_instance_count
  ami           = local.ec2_ami
  instance_type = var.aws_instance_config.master_instance_type
  private_ip    = var.aws_instance_config.k8s_master_private_ips[count.index]

  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.k8s_masters_sg.id]
  key_name               = module.keypair.key_name
  tags = {
    Name = "${var.aws_project}-k8s-masters-${count.index}"
  }
}

# Create Kubernetes Worker Nodes
resource "aws_instance" "k8s_workers" {
  count         = var.aws_instance_config.k8s_workers_instance_count
  ami           = local.ec2_ami
  instance_type = var.aws_instance_config.workers_instance_type
  private_ip    = var.aws_instance_config.k8s_worker_private_ips[count.index]

  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.k8s_workers_sg.id]
  key_name               = module.keypair.key_name
  tags = {
    Name = "${var.aws_project}-k8s-workers-${count.index}"
  }
}

resource "null_resource" "set_up_openvpn_server" {
  depends_on = [ module.eip-management_server, aws_instance.management_server ]

  triggers = {
    instance_id = aws_instance.management_server[0].id
    eip        = module.eip-management_server.public_ips[0]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = module.eip-management_server.public_ips[0]
    private_key = file("${path.module}/${var.aws_project}-key.pem")
    agent = false
  }

  provisioner "file" {
    source      = "./scripts/openvpn-install.sh"
    destination = "/home/ubuntu/openvpn-install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/openvpn-install.sh",
      "sudo /home/ubuntu/openvpn-install.sh"
    ]
  }
}
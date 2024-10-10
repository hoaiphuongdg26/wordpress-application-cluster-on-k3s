# modules/ec2/main.tf

# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "ubuntu_20_04" {
  most_recent = true
  owners      = ["099720109477"] # ID của Canonical, nhà phát triển Ubuntu

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "keypair_master" {
  source         = "../keypair"
  environment    = var.environment
  instance_count = var.master_count
  instance_type  = "master"
}

module "keypair_worker" {
  source         = "../keypair"
  environment    = var.environment
  instance_count = var.worker_count
  instance_type  = "worker"
}


# EC2 Instance Master
resource "aws_instance" "master" {
  count         = var.master_count
  ami           = data.aws_ami.ubuntu_20_04.id
  instance_type = var.instance_type_master

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.public_sg_id]
  associate_public_ip_address = true

  key_name = module.keypair_master.key_name[count.index]
  tags = {
    name = "${var.environment}-master-ec2-${count.index + 1}"
  }
}

# EC2 Instance Worker
resource "aws_instance" "worker" {
  count         = var.worker_count
  ami           = data.aws_ami.ubuntu_20_04.id
  instance_type = var.instance_type_worker

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.public_sg_id]
  associate_public_ip_address = true

  key_name = module.keypair_worker.key_name[count.index]

  tags = {
    name = "${var.environment}-worker-ec2-${count.index + 1}"
  }
}

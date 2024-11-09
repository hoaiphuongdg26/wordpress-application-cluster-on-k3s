# aws-terraform-infrastructure/modules/ec2/main.tf
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

# EC2 Instance
resource "aws_instance" "this" {
  count         = var.instance_count
  ami           = local.ec2_ami
  instance_type = var.instance_type
  private_ip    = var.private_ips[count.index]

  subnet_id              = var.subnets_id[count.index % length(var.subnets_id)]
  vpc_security_group_ids = var.sgs_id
  key_name               = var.key_name
  tags = {
    Name = "${var.name}-instance-${count.index}"
  }
}
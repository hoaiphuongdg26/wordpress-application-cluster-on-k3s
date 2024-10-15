# modules/security_groups/main.tf

# Public EC2 Security Group
resource "aws_security_group" "public_ec2" {
  name        = "${var.environment}-public-ec2-sg"
  description = "Security group for public EC2 instances"
  vpc_id      = var.vpc_id

  # Allow all traffic from the same security group
  ingress {
    description     = "Allow all inbound traffic from instances in the same security group"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = true
  }
  
  # Allow SSH
  ingress {
    description = "SSH from specific IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  # Allow HTTP (port 80)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS (port 443)
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Kubernetes API Server (port 6443)
  ingress {
    description = "Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Kubelet (port 10250)
  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Kube-scheduler (port 10251)
  ingress {
    description = "Kube-scheduler"
    from_port   = 10251
    to_port     = 10251
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Kube-controller-manager (port 10252)
  ingress {
    description = "Kube-controller-manager"
    from_port   = 10252
    to_port     = 10252
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow NodePort services (port range 30000-32767)
  ingress {
    description = "NodePort services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-public-ec2-sg"
  }
}

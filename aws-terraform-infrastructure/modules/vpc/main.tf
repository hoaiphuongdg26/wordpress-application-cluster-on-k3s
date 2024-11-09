# aws-terraform-infrastructure/modules/vpc/main.tf
# VPC Module
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = "${var.name}-VPC"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index % length(var.availability_zones))
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnets_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index % length(var.availability_zones))

  tags = {
    Name = "${var.name}-private-subnet-${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-IGW"
  }
}

# Nat Gateway
module "nat" {
  source           = "../nat"
  enable_nat_gateway       = var.enable_nat_gateway
  name             = var.name
  public_subnet_id = aws_subnet.public[0].id  # Sử dụng subnet đầu tiên được tạo
}

# Route Tables
module "route_tables" {
  source              = "../route_tables"
  vpc_id              = aws_vpc.main.id
  name                = var.name
  internet_gateway_id = aws_internet_gateway.main.id
  nat_gateway_id      = module.nat.nat_gateway_id
  enable_nat_gateway  = var.enable_nat_gateway
  public_subnet_ids   = aws_subnet.public[*].id
  private_subnet_ids  = aws_subnet.private[*].id
}
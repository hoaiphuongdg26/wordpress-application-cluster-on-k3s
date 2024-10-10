# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  region              = var.region
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
  availability_zones  = var.availability_zones
}

module "security_groups" {
  source = "./modules/security_groups"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  allowed_ip  = var.allowed_ip

  depends_on = [module.vpc]
}

module "route_tables" {
  source     = "./modules/route_tables"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.vpc.public_subnets[0]]
  routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.vpc.internet_gateway_id
    }
  ]
  environment = var.environment
  depends_on  = [module.vpc]
}

module "ec2" {
  source = "./modules/ec2"

  environment          = var.environment
  instance_type_master = var.instance_type_master
  instance_type_worker = var.instance_type_worker
  public_subnet_id     = module.vpc.public_subnets[0]
  public_sg_id         = module.security_groups.public_sg_id
  master_count         = var.master_count
  worker_count         = var.worker_count
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "default"
}

variable "aws_environment" {
  description = "Environment"
  type        = string
}

variable "aws_project" {
  description = "Project"
  type        = string
}

variable "aws_owner" {
  description = "Owner"
  type        = string
}

variable "aws_vpc_config" {
  description = "VPC configuration"
  type = object({
    cidr_block                   = string,
    enable_dns_support           = bool,
    enable_dns_hostnames         = bool,
    public_subnets_cidr          = list(string),
    private_subnets_cidr         = list(string),
    number_of_availability_zones = number,
    enable_nat_gateway           = bool
  })
}

variable "aws_instance_config" {
  description = "Instance configuration"
  type = object({
    key_name = string,
    management_private_ips = list(string),
    k8s_master_private_ips = list(string),
    k8s_worker_private_ips = list(string),
    management_instance_count = number,
    k8s_workers_instance_count = number,
    k8s_master_instance_count = number,
    management_instance_type = string,
    cluster_instance_type = string
  })
}
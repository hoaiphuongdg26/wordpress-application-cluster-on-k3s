# Root variables.tf

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnets_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "allowed_ip" {
  description = "IP address allowed to connect to public EC2"
  type        = string
}

variable "instance_type_master" {
  description = "Instance type for EC2 instances Master"
  type        = string
}

variable "instance_type_worker" {
  description = "Instance type for EC2 instances Worker"
  type        = string
}

variable "master_count" {
  description = "Number of Master EC2 instances"
  type        = number
}

variable "worker_count" {
  description = "Number of Worker EC2 instances"
  type        = number
}

# modules/ec2/variables.tf

variable "environment" {
  description = "Environment name"
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

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "public_sg_id" {
  description = "Public security group ID"
  type        = string
}

variable "master_count" {
  description = "Number of Master EC2 instances"
  type        = number
  default     = 1
}

variable "worker_count" {
  description = "Number of Worker EC2 instances"
  type        = number
  default     = 2
}

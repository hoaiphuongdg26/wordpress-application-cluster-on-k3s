# modules/security_groups/variables.tf

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "allowed_ip" {
  description = "IP address allowed to connect to public EC2"
  type        = string
}
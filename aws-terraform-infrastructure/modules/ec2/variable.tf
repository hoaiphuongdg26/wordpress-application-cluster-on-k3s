variable "name" {
  description = "Name of the EC2 instances"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

variable "subnets_id" {
  description = "Subnet ID for the EC2 instances"
  type        = list(string)
}

variable "sgs_id" {
  description = "Security Group ID for the EC2 instances"
  type        = list(string)
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
}

variable "key_name" {
  description = "Key pair name for the EC2 instances"
  type        = string
}

variable "private_ips" {
  description = "Private IP addresses for the EC2 instances"
  type        = list(string)
}
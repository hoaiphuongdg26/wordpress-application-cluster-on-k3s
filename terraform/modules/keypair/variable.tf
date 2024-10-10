# modules/keypair/variables.tf

variable "environment" {
  description = "Environment name"
  type        = string
}
variable "instance_count" {
  description = "Số lượng instance"
  type        = number
}
variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

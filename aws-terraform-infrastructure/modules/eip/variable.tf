
# variables.tf
variable "create_eip" {
  description = "Whether to create EIP"
  type        = bool
  default     = true
}

variable "instance_ids" {
  description = "List of EC2 instance IDs to attach EIP"
  type        = list(string)
}

variable "name" {
  description = "Name prefix for EIP"
  type        = string
}

variable "internet_gateway" {
  description = "Internet Gateway ID"
  type        = any
}
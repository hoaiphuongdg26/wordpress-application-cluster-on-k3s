# nat/variables.tf

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name prefix for the NAT Gateway resources"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet where the NAT Gateway will be placed"
  type        = string
}

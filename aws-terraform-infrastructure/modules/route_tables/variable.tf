# modules/route_table/variables.tf

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the route table"
  type        = list(string)
}

variable "routes" {
  description = "List of routes to be added to the route table"
  type = list(object({
    cidr_block = string
    gateway_id = string
  }))
}

variable "environment" {
  description = "Environment name"
  type        = string
}

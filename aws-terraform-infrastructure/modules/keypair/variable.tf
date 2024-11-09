variable "name" {
  description = "Name of the key pair"
  type        = string
}

variable "algorithm" {
  description = "Algorithm for the key pair"
  type        = string
  default     = "RSA"
}

# Root outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "public_security_group_id" {
  description = "ID of the public EC2 security group"
  value       = module.security_groups.public_sg_id
}

output "masters" {
  description = "Information of all EC2 instance Masters"
  value       = module.ec2.master_info
}

output "workers" {
  description = "Information of all EC2 instance Worker"
  value       = module.ec2.worker_info
}
# modules/security_groups/outputs.tf

output "public_sg_id" {
  value = aws_security_group.public_ec2.id
}
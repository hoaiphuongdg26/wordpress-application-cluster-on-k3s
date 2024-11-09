# outputs.tf
# output "eip_ids" {
#   value = aws_eip.this[*].id
# }

output "public_ips" {
  value = aws_eip.this[*].public_ip
}

output "dns_names" {
  value = aws_eip.this[*].public_dns
}
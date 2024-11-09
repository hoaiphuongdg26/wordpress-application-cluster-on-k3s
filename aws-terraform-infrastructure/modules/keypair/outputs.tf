output "key_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.this.key_name
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = local_file.private_key.filename
}

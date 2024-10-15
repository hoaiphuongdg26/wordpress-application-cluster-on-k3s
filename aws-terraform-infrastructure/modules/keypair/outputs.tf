# modules/keypair/outputs.tf

output "key_name" {
  description = "Name of the key pair"
  value       = [for k in aws_key_pair.this : k.key_name] # Xuất tất cả key names
}

output "private_key_paths" {
  description = "Paths to the private key files"
  value       = local_file.private_key[*].filename # Xuất ra danh sách đường dẫn file chứa khóa riêng
}

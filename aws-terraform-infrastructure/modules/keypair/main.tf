# modules/keypair/main.tf

resource "tls_private_key" "this" {
  count     = var.instance_count
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  count      = var.instance_count
  key_name   = "${var.environment}-${var.instance_type}-${count.index + 1}"
  public_key = tls_private_key.this[count.index].public_key_openssh
}

resource "local_file" "private_key" {
  count           = var.instance_count
  content         = tls_private_key.this[count.index].private_key_pem
  filename        = "${path.root}/keys/${var.environment}-${var.instance_type}-${count.index + 1}.pem"
  file_permission = "0400"
}

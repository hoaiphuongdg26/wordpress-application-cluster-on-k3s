# Key Pair Module
resource "tls_private_key" "this" {
  algorithm = var.algorithm
}

resource "aws_key_pair" "this" {
  key_name   = "${var.name}-key"
  public_key = tls_private_key.this.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.this.private_key_openssh
  filename        = "${path.root}/${var.name}-key.pem"
  file_permission = "0600"
}

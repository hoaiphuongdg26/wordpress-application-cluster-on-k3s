# modules/eip/main.tf
resource "aws_eip" "this" {
  count    = var.create_eip ? length(var.instance_ids) : 0
  domain   = "vpc"
  instance = var.instance_ids[count.index]

  depends_on = [var.internet_gateway]

  tags = {
    Name = "${var.name}-eip-${count.index}"
  }
}
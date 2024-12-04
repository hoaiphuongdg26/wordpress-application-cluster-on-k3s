# modules/eip/main.tf
resource "aws_eip" "this" {
  count    = var.create_eip ? length(var.instance_ids) : 0
  domain   = "vpc"

  depends_on = [var.internet_gateway]

  tags = {
    Name = "${var.name}-eip-${count.index}"
  }
}

resource "aws_eip_association" "this" {
  count         = var.create_eip ? length(var.instance_ids) : 0
  instance_id   = var.instance_ids[count.index]
  allocation_id = aws_eip.this[count.index].id

  depends_on = [
    aws_eip.this,
    var.internet_gateway
  ]
}
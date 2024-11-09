# ./modules/nat/main.tf
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0
  tags = {
    Name = "${var.name}-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "${var.name}-nat-gateway"
  }
}
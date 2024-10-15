# modules/route_tables/main.tf

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.routes
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.gateway_id
    }
  }

  tags = {
    Name = "${var.environment}-route-table"
  }
}

resource "aws_route_table_association" "this" {
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.this.id
}

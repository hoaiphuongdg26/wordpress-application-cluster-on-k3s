# Security group module
resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = var.description
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg"
  }
}

# Ingress rules
resource "aws_vpc_security_group_ingress_rule" "ingress_with_cidr" {
  count             = length(var.ingress_rules_with_cidr)
  security_group_id = aws_security_group.this.id
  description       = var.ingress_rules_with_cidr[count.index].description
  from_port         = var.ingress_rules_with_cidr[count.index].from_port
  to_port           = var.ingress_rules_with_cidr[count.index].to_port
  ip_protocol       = var.ingress_rules_with_cidr[count.index].protocol
  cidr_ipv4         = var.ingress_rules_with_cidr[count.index].ip
}

resource "aws_vpc_security_group_ingress_rule" "ingress_with_security_group" {
  count                        = length(var.ingress_rules_with_security_group)
  security_group_id            = aws_security_group.this.id
  description                  = var.ingress_rules_with_security_group[count.index].description
  from_port                    = var.ingress_rules_with_security_group[count.index].from_port
  to_port                      = var.ingress_rules_with_security_group[count.index].to_port
  ip_protocol                  = var.ingress_rules_with_security_group[count.index].protocol
  referenced_security_group_id = var.ingress_rules_with_security_group[count.index].security_group_id
}

# Egress rules
resource "aws_vpc_security_group_egress_rule" "egress_with_cidr" {
  count             = length(var.egress_rules_with_cidr)
  security_group_id = aws_security_group.this.id
  description       = var.egress_rules_with_cidr[count.index].description
  from_port         = var.egress_rules_with_cidr[count.index].from_port
  to_port           = var.egress_rules_with_cidr[count.index].to_port
  ip_protocol       = var.egress_rules_with_cidr[count.index].protocol
  cidr_ipv4         = var.egress_rules_with_cidr[count.index].ip
}

resource "aws_vpc_security_group_egress_rule" "egress_with_security_group" {
  count                        = length(var.egress_rules_with_security_group)
  security_group_id            = aws_security_group.this.id
  description                  = var.egress_rules_with_security_group[count.index].description
  from_port                    = var.egress_rules_with_security_group[count.index].from_port
  to_port                      = var.egress_rules_with_security_group[count.index].to_port
  ip_protocol                  = var.egress_rules_with_security_group[count.index].protocol
  referenced_security_group_id = var.egress_rules_with_security_group[count.index].security_group_id
}
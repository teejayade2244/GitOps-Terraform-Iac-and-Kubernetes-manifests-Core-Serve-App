
resource "aws_security_group" "main_sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id
  

  # Dynamic ingress rules
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Dynamic egress rules
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name    = var.sg_name
    Environment = var.environment
  }
}
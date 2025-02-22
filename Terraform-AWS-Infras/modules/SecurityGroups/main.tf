# Define common ports and rules
locals {
  common_ports = {
    ssh = {
      from_port   = 22
      to_port     = 22
      description = "Allow SSH traffic"
    }
    http = {
      from_port   = 80
      to_port     = 80
      description = "Allow HTTP traffic"
    }
      https = {
      from_port   = 443
      to_port     = 443
      description = "Allow HTTPS traffic"
    }
  }
}

# Define egress rule
locals {
  security_groups = {
    my_sg       = aws_security_group.my-sg.id
    main_ec2_sg = aws_security_group.sg_for_main_Ec2.id
  }
}


# Base security group
resource "aws_security_group" "my-sg" {
  name        = "security-group"
  description = "Security group for allowing access"
  vpc_id      = var.vpc_id
}

# Dynamic block for common ingress rules
resource "aws_vpc_security_group_ingress_rule" "common_rules" {
  for_each = local.common_ports

  security_group_id = aws_security_group.my-sg.id
  cidr_ipv4        = var.cidr_block
  from_port        = each.value.from_port
  to_port          = each.value.to_port
  ip_protocol      = "tcp"
  description      = each.value.description

  tags = {
    Name = "Allow ${each.key}"
  }
}

# Egress Rule
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  for_each          = local.security_groups
  security_group_id = each.value
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"

  tags = {
    Name = "Allow all outbound for ${each.key}"
  }
}


#################################################################################################################

# Main EC2 Security Group
resource "aws_security_group" "sg_for_main_Ec2" {
  name        = "Main-EC2-sg"
  description = "Security group for Main EC2 instance"
  vpc_id      = var.vpc_id
}

# Dynamic block for inherited rules from my-sg
resource "aws_security_group_rule" "inherited_rules" {
  for_each = local.common_ports

  type                     = "ingress"
  security_group_id        = aws_security_group.sg_for_main_Ec2.id
  source_security_group_id = aws_security_group.my-sg.id
  from_port               = each.value.from_port
  to_port                 = each.value.to_port
  protocol                = "tcp"
  description             = "${each.value.description} (inherited)"
}

# Additional port 8080 for jenkins rule
resource "aws_vpc_security_group_ingress_rule" "allow_8080" {
  security_group_id = aws_security_group.sg_for_main_Ec2.id
  from_port        = 8080
  to_port          = 8080
  ip_protocol      = "tcp"
  cidr_ipv4        = var.cidr_block
  description      = "Allow 8080 traffic"
}

# Additional port 9000 for sonarqube rule
resource "aws_vpc_security_group_ingress_rule" "allow_8080" {
  security_group_id = aws_security_group.sg_for_main_Ec2.id
  from_port        = 9000
  to_port          = 9000
  ip_protocol      = "tcp"
  cidr_ipv4        = var.cidr_block
  description      = "Allow 8080 traffic"
}



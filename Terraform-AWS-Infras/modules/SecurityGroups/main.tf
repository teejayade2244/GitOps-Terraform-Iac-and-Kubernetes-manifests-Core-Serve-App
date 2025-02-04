resource "aws_security_group" "my-sg" {
  name        = "security-group"
  description = "Security group for allowing access"
  vpc_id      = var.vpc_id 
}

# Create an ingress rule for SSH
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my-sg.id
  cidr_ipv4         = var.cidr_block # Open IPs within this range
  from_port         = 22            # SSH port
  to_port           = 22
  ip_protocol       = "tcp"

  tags = {
    Name = "Allow SSH"
  }
}

# Ingress Rule 2: Allow HTTP (port 80)
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my-sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = var.cidr_block
  description       = "Allow HTTP traffic"
}

# Egress Rule: Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.my-sg.id
  ip_protocol          = "-1" # All protocols
  cidr_ipv4       = "0.0.0.0/0"
  description       = "Allow all outbound traffic"
}

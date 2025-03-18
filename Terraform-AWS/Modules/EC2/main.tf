resource "aws_instance" "ec2_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]  # Note: This expects a single ID, not a list
  tags = {
    Name = var.server_name
  }
}
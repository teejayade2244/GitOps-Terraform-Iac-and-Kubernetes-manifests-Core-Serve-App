output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "private_subnets" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block 
}

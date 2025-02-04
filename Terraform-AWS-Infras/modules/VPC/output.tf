output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "private-subnets" {
  value = aws_subnet.private-subnets.id
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block 
}

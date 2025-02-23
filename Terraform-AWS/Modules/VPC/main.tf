#create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block 
  tags = {
    Name = "main"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.main.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

#subnet creation
#public subnets
#Each subnet is assigned to a different Availability Zone (AZ) to ensure high availability.
resource "aws_subnet" "public_subnets" {
  for_each = var.Public_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = true  #Allows EC2 instances in these subnets to be publicly accessible.
  tags = {
    Name = each.key
  }
}


# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "Public-rt"
  }
}


# associate public subnets to public route table
resource "aws_route_table_association" "public-subnet_route_table_association" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

#private subnets
resource "aws_subnet" "private_subnets" {
  for_each = var.Private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = each.key
  }
}
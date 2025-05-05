#create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block 
  tags = {
    Name = "main"
    Environment = var.environment
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.main.id

  tags      = {
    Name    = "${var.project_name}-igw"
    Environment = var.environment
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
    Environment = var.environment
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
    Environment = var.environment
  }
}

# associate public subnets to public route table
resource "aws_route_table_association" "public-subnet_route_table_association" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

############################################################################################################
# private subnets
resource "aws_subnet" "private_subnets" {
  for_each = var.Private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = each.key
    Environment = var.environment
  }
}

# create route table and add private route
resource "aws_route_table" "private_route_table" {
  vpc_id       = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
     nat_gateway_id = aws_nat_gateway.nat_gateway.id
    
  }
  tags       = {
    Name     = "Private-rt"
    Environment = var.environment
  }
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_subnet_route_table_association" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}

# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

# Create the NAT Gateway in the public subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = values(aws_subnet.public_subnets)[0].id
   tags = {
    Name = "${var.project_name}-nat-gw"
    Environment = var.environment
  }
  depends_on = [aws_internet_gateway.internet_gateway]
}


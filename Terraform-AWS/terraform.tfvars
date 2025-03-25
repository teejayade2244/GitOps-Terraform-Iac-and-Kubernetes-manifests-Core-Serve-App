#VPC and subnets
cidr_block = "10.0.0.0/16"
Public_subnets = {
  publicSubnet1a = { cidr = "10.0.1.0/24", az = "eu-west-2a" }
  publicSubnet1b = { cidr = "10.0.2.0/24", az = "eu-west-2b" }
}

Private_subnets = {
  privateSubnet1a = { cidr = "10.0.3.0/24", az = "eu-west-2a" }
  privateSubnet1b = { cidr = "10.0.4.0/24", az = "eu-west-2b" }
}
project_name = "Blackrose"
region = "eu-west-2"

#############################################################################

# Common Ingress Rules (Used in Both Security Groups)
common_ingress_rules = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
   {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
]

###############################################################################################
# Security Group 1 (Main SG)
main_sg1_name        = "Main-SG"
main_sg1_description = "General Purpose Security Group"
main_sg1_extra_ports = []

# EC2 Security Group  (Extra SG with Port 8080)
EC2_sg_name        = "Main EC2-SG"
EC2_sg_description = "Security Group for EC2"
EC2_sg_extra_ports = [
  {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
   {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
]

#######################################################################################
# S3 Buckets
# Remote Backend

########################################################################################
# Dynamo DB
# Remote Backend

##########################################################################################
# EC2
# main server
ami = "ami-091f18e98bc129c4e"
instance_type = "t2.large"
server_name = "Master-Server"

# ECR
###############################################################################################
repository_name = "core-serve-frontend-app"
environment = "Development"
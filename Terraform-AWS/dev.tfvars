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
project_name = "core-serve-app"
region = "eu-west-2"
environment = "Development"

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
# Security Groups
security_groups = {
  # main security group
  main = {
    name        = "Main-SG"
    description = "General Purpose Security Group"
    extra_ports  = [
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
     tags = {}
  },

  # EC2 security group
  ec2 = {
    name        = "ec2-sg"
    description = "Security Group for EC2"
    extra_ports  = []
    tags = {}
  }
}
#######################################################################################
# S3 Buckets
bucket_name = "core-serve-frontend-jenkins-build-reports"
bucket_description = "S3 bucket for core-serve-frontend-app Jenkins reports uploads"

########################################################################################
# Dynamo DB
# Remote Backend

##########################################################################################
# EC2
# main server
ami = "ami-091f18e98bc129c4e"
instance_type = ["t2.micro", "t2.medium", "t2.large", "t2.xlarge", "t2.2xlarge"]
server_name = "Dev-Master-Server"


# ECR
###############################################################################################
repository_name = "core-serve-frontend-app"

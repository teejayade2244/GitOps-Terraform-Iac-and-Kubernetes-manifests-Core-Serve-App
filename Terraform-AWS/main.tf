# VPC
# This module will create a VPC in the eu-west region where the AWS resources will be deployed
module "VPC" {
  source          = "./Modules/VPC"
  cidr_block      = var.cidr_block
  Public_subnets  = var.Public_subnets
  Private_subnets = var.Private_subnets
  project_name    = var.project_name
}

####################################################################################################################
#  Main security Group
# This module will create a SG for general purpose
module "main_security_group" {
  source = "./Modules/Security-group"
  sg_name        = var.main_sg1_name
  sg_description = var.main_sg1_description
  vpc_id         = module.VPC.vpc_id
  ingress_rules  = concat(var.common_ingress_rules, var.main_sg1_extra_ports)
   egress_rules  = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name = var.main_sg1_name
  }
  
}

# MAIN EC2 SECURITY GROUP
# This module will create a SG for the main EC2 instance to run jenkins server and sonarqube etc
module "EC2_security_group_app" {
  source = "./Modules/Security-group"
  sg_name       = var.EC2_sg_name 
  sg_description = var.EC2_sg_description
  vpc_id        = module.VPC.vpc_id
  ingress_rules = concat(var.common_ingress_rules, var.EC2_sg_extra_ports)
  egress_rules  = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name = var.EC2_sg_name
  }
}

# Security Group for Blackrose frontend App
module "Frontend_security_group_app" {
  source = "./Modules/Security-group"
  sg_name       = "Frontend"
  sg_description = "SG for Frontend APP"
  vpc_id        = module.VPC.vpc_id
  ingress_rules = concat(var.common_ingress_rules, [
    {
      from_port   = 30004
      to_port     = 30004
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ])

  egress_rules  = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name = "Frontend"
  }
}

##########################################################################################################
# EC2

module "main_server" {
  source = "./Modules/EC2"
  ami           = var.ami
  instance_type = var.instance_type
  security_group_id = module.EC2_security_group_app.security_group_id
  subnet_id     = element(module.VPC.public_subnet_ids, 0) # Using first public subnet
  server_name   = "${var.server_name}-public"
}

module "frontend_server" {
  source = "./Modules/EC2"
  ami           = var.ami
  instance_type = "t2.micro"
  security_group_id = module.Frontend_security_group_app.security_group_id  
  subnet_id     = module.VPC.private_subnet_ids[1]  # Using second private subnet
  server_name   = "${var.server_name}-private"
}
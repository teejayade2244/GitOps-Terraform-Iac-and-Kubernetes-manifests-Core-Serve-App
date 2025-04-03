# VPC
# This module will create a VPC in the eu-west region where the AWS resources will be deployed
module "VPC" {
  source          = "./Modules/VPC"
  cidr_block      = var.cidr_block
  Public_subnets  = var.Public_subnets
  Private_subnets = var.Private_subnets
  project_name    = var.project_name
  environment     = var.environment
}

####################################################################################################################
#  Main security Group
# This module will create a SG for general purpose
module "main_security_group" {
  source = "./Modules/Security-group"
  sg_name        = var.security_groups["main"].name
  sg_description = var.security_groups["main"].description
  vpc_id         = module.VPC.vpc_id
  environment    = var.environment
  ingress_rules  = concat(
    var.common_ingress_rules,
    var.security_groups["main"].extra_ports
  )
  egress_rules = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
  tags = {
    Environment = var.environment
  }
}

# MAIN EC2 SECURITY GROUP
# This module will create a SG for the main EC2 instance to run jenkins server and sonarqube etc
module "EC2_security_group_app" {
  source = "./Modules/Security-group"
  sg_name        = var.security_groups["ec2"].name
  sg_description = var.security_groups["ec2"].description
  vpc_id         = module.VPC.vpc_id
  environment    = var.environment
  ingress_rules  = concat(
    var.common_ingress_rules,
    var.security_groups["ec2"].extra_ports
  )
  egress_rules = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
  tags = {
    Environment = var.environment
  }
}


##########################################################################################################
# EC2
## Jenkins server
module "main_server" {
  source = "./Modules/EC2"
  ami           = var.ami
  instance_type = var.instance_type[2]
  security_group_id = module.main_security_group.security_group_id
  subnet_id     = element(module.VPC.public_subnet_ids, 0) # Using first public subnet
  server_name   = "${var.server_name}-public"
  enable_provisioner = true 
  environment = var.environment
}

## Frontend server
module "frontend_server" {
  source = "./Modules/EC2"
  ami           = var.ami
  instance_type = var.instance_type[0]
  security_group_id = module.EC2_security_group_app.security_group_id  
  subnet_id     = module.VPC.private_subnet_ids[1]  # Using second private subnet
  server_name   = "web-server"
  enable_provisioner = false
  environment = var.environment
}

##############################################################################################################
module "ecr" {
  source          = "./Modules/ECR"
  repository_name = var.repository_name
  environment     = var.environment
}


####################################################################################################################
module "s3" {
  source = "./Modules/S3"
  bucket_name        = var.bucket_name
  bucket_description = var.bucket_description
}

####################################################################################################################
module "SSM" {
  source = "./Modules/SSM"
  name        = var.name
  description = var.description
  type        = var.type
  value       = var.value
  tags        = {
    Environment = var.environment
  }
}
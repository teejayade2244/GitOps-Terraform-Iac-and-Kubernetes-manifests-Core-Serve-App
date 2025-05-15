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
# security Groups
# Bastion Host security group
module "Bastion_host_security_group" {
  source = "./Modules/Security-group"
  sg_name        = var.security_groups["bastion"].name
  sg_description = var.security_groups["bastion"].description
  vpc_id         = module.VPC.vpc_id
  environment    = var.environment
  ingress_rules  = [{
    from_port   = 22
    to_port     = 22
    description = "SSH access"
    protocol    = "tcp"
    cidr_blocks = ["151.230.33.76/32"]
  }]
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

# This module will create a SG for general purpose
module "Jenkins_master_security_group" {
  source = "./Modules/Security-group"
  sg_name        = var.security_groups["master"].name
  sg_description = var.security_groups["master"].description
  vpc_id         = module.VPC.vpc_id
  environment    = var.environment
  ingress_rules  = concat(
  [{
    from_port   = 22
    to_port     = 22
    description = "SSH access"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }],
    var.security_groups["master"].extra_ports
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

##############################################################################################################
# IAM Roles
module "eks_cluster_role" {
  source             = "./Modules/IAM"
  role_name               = "${var.cluster_name}-cluster-role"
  role_description        = "IAM role for EKS control plane"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
}

module "eks_nodegroup_role" {
  source             = "./Modules/IAM"
  role_name               = "${var.cluster_name}-nodegroup-role"
  role_description        = "IAM role for EKS nodes"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

# MAIN EC2 SECURITY GROUP
# This module will create a SG for the main EC2 instance to run jenkins server and sonarqube etc
module "Jenkins_slave_security_group" {
  source = "./Modules/Security-group"
  sg_name        = var.security_groups["slave"].name
  sg_description = var.security_groups["slave"].description
  vpc_id         = module.VPC.vpc_id
  environment    = var.environment
  ingress_rules  = concat(
  [{
    from_port   = 22
    to_port     = 22
    description = "SSH access"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }],
    var.security_groups["master"].extra_ports
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
# Bastion Host
module "Bastion_server" {
  source = "./Modules/EC2"
  ami           = var.ami
  instance_type = var.instance_type[0]
  security_group_id = module.Bastion_host_security_group.security_group_id
  subnet_id     = element(module.VPC.public_subnet_ids, 0) # Using first public subnet
  server_name   = "Bastion-Host"
  enable_provisioner = false
  environment = var.environment
  root_volume_size = var.root_volume_size
  root_volume_type = var.root_volume_type
  delete_on_termination = var.delete_on_termination
}
## Jenkins server
module "jenkins_master_server" {
  source = "./Modules/EC2"
  ami           = var.ami
  instance_type = var.instance_type[1]
  security_group_id = module.Jenkins_master_security_group.security_group_id
  subnet_id     = element(module.VPC.public_subnet_ids, 0) # Using first public subnet
  server_name   = "Jenkins-Master-Controller"
  enable_provisioner = true 
  environment = var.environment
  root_volume_size = var.root_volume_size
  root_volume_type = var.root_volume_type
  delete_on_termination = var.delete_on_termination
}

## Jenkins slaves
module "Jenkins_slave_server_1" {
  source = "./Modules/EC2"
  ami           = var.ami
  instance_type = var.instance_type[1]
  security_group_id = module.Jenkins_slave_security_group.security_group_id  
  subnet_id     = module.VPC.public_subnet_ids[1]  # Using second private subnet
  server_name   = "Jenkins-worker-node(1)"
  enable_provisioner = false
  environment = var.environment
  root_volume_size = 20
  root_volume_type = var.root_volume_type
  delete_on_termination = var.delete_on_termination
}

module "Jenkins_slave_server_2" {
  source = "./Modules/EC2"
  ami           = var.ami
  instance_type = var.instance_type[1]
  security_group_id = module.Jenkins_slave_security_group.security_group_id  
  subnet_id     = module.VPC.public_subnet_ids[1]  # Using second private subnet
  server_name   = "Jenkins-worker-node(2)"
  enable_provisioner = false
  environment = var.environment
  root_volume_size = 20
  root_volume_type = var.root_volume_type
  delete_on_termination = var.delete_on_termination
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
locals {
  tfvars_content = file("../Terraform-AWS/dev.tfvars")
}

module "SSM" {
  source      = "./Modules/SSM"
  name        = var.name
  description = var.description
  type        = var.type
  value       = local.tfvars_content  
  tags        = {
    Environment = var.environment
  }
}

####################################################################################################################
# EKS CLuster

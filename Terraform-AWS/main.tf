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
# This module will create a SG for the EKS cluster
module "EKS_cluster_security_group" {
  source = "./Modules/Security-group"
  sg_name        = var.security_groups["EKS_cluster"].name
  sg_description = var.security_groups["EKS_cluster"].description
  vpc_id         = module.VPC.vpc_id
  environment    = var.environment
  ingress_rules  = var.security_groups["EKS_cluster"].extra_ports
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

module "EKS_node_group_security_group" {
  source = "./Modules/Security-group"
  sg_name        = var.security_groups["EKS_node_group"].name
  sg_description = var.security_groups["EKS_node_group"].description
  vpc_id         = module.VPC.vpc_id
  environment    = var.environment
  ingress_rules  = var.security_groups["EKS_node_group"].extra_ports
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
# main.tf (UPDATED - as provided in previous response, confirming validity with your module outputs)

# IAM Users
# This module will create IAM users for developers group
module "developers" {
  source               = "./Modules/IAM-user"
  for_each             = toset(var.developers_usernames)
  user_name            = each.key
  create_login_profile = true
  create_access_key    = false
  tags = {
    Environment = var.environment
  }
}

# This module will create IAM users for admins group
module "admins" {
  source               = "./Modules/IAM-user"
  for_each             = toset(var.admins_usernames)
  user_name            = each.key
  create_login_profile = true
  create_access_key    = false
  tags = {
    Environment = var.environment
  }
}

# Developer Group
# This module will create an IAM group for developers and attach policies
# to it. The group will contain the developers' IAM users.
module "developers_group" {
  source     = "./Modules/IAM-group"
  group_name = "developers"
  user_names = var.developers_usernames
  policy_arns = [
    module.iam_policies["eks_developer"].policy_arn # Corrected reference
  ]
}

# Admin Group
# This module will create an IAM group for admins and attach policies
# to it. The group will contain the admins' IAM users.
module "admins_group" {
  source     = "./Modules/IAM-group"
  group_name = "admins"
  user_names = var.admins_usernames
  policy_arns = [
    module.iam_policies["eks_admin"].policy_arn # Corrected reference
  ]
}

# IAM Roles
# This module will create IAM roles for EKS cluster and node groups
# and attach the necessary policies to them.
data "aws_caller_identity" "current" {}
module "iam_roles" {
  for_each = var.iam_roles
  source           = "./Modules/IAM-roles"
  role_name        = "${var.cluster_name}-${each.value.name}"
  role_description = each.value.description
    assume_role_policy = each.value.principal_type == "Service" ? jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = each.value.principal_service
        }
      }]
    }) : jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          AWS = (
            each.key == "admin_role" ? [for user in var.admins_usernames : module.admins[user].arn] :
            each.key == "developer_role" ? [for user in var.developers_usernames : module.developers[user].arn] :
            ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
          )
        }
      }]
    })

  # Pass the list of policy ARNs as an input variable
  policy_arns = concat(
    each.value.policy_arns,
    each.key == "admin_role" ? [module.iam_policies["eks_admin"].policy_arn] : [],
    each.key == "jenkins_role" ? [module.iam_policies["jenkins"].policy_arn] : [],
    each.key == "developer_role" ? [module.iam_policies["eks_developer"].policy_arn] : []
  )
  # Pass the create_instance_profile flag, if your module expects it
  create_instance_profile = each.key == "nodegroup_role" ? true : false
}

# IAM Policies
# This module will create IAM policies based on the provided configuration
# and attach them to the respective roles and groups.
module "iam_policies" {
  source             = "./Modules/IAM-policy"
  for_each           = var.iam_policies 
  policy_name        = each.value.name
  policy_description = each.value.description
  policy_document    = local.iam_policy_documents[each.key] 
}
##############################################################################################################
# EC2
# Bastion Host
# module "Bastion_server" {
#   source = "./Modules/EC2"
#   ami           = var.ami
#   instance_type = var.instance_type[0]
#   security_group_id = module.Bastion_host_security_group.security_group_id
#   subnet_id     = element(module.VPC.public_subnet_ids, 0) # Using first public subnet
#   server_name   = "Bastion-Host"
#   enable_provisioner = false
#   environment = var.environment
#   root_volume_size = var.root_volume_size
#   root_volume_type = var.root_volume_type
#   delete_on_termination = var.delete_on_termination
# }
## Jenkins server
module "jenkins_master_server" {
  source = "./Modules/EC2"
  ami           = var.ami
  instance_type = var.instance_type[4]
  security_group_id = module.Jenkins_master_security_group.security_group_id
  subnet_id     = element(module.VPC.public_subnet_ids, 0) # Using first public subnet
  server_name   = "Jenkins-Master-Controller"
  enable_provisioner = true 
  environment = var.environment
  root_volume_size = var.root_volume_size
  root_volume_type = var.root_volume_type
  delete_on_termination = var.delete_on_termination
  iam_instance_profile = module.iam_roles["jenkins_role"].instance_profile_name
}

##############################################################################################################
module "ecr" {
  source    = "./Modules/ECR"
  for_each  = var.ecr_repositories
  repository_name       = each.value.name
  environment          = each.value.environment
  image_tag_mutability = each.value.image_tag_mutability
  scan_on_push        = each.value.scan_on_push
}

####################################################################################################################
module "s3" {
  source = "./Modules/S3"
  bucket_name        = var.bucket_name
  bucket_description = var.bucket_description
}

module "s3_EKS_Access_entry_Scripts" {
  source = "./Modules/S3"
  bucket_name        = "eks-access-entry-scripts"
  bucket_description = "S3 bucket for EKS Access Entry Scripts"
  
}

# Uploading scripts to S3 bucket for EKS access entries
resource "aws_s3_object" "eks_admin_script" {
  bucket = module.s3_EKS_Access_entry_Scripts.bucket_id
  key    = "EKS-admin.sh"
  source = "../EKS-admin.sh"
  content_type = "text/x-shellscript"
  etag   = filemd5("../EKS-admin.sh")
}

resource "aws_s3_object" "eks_dev_script" {
  bucket = module.s3_EKS_Access_entry_Scripts.bucket_id
  key    = "EKS-dev.sh"
  source = "../EKS-dev.sh"
  content_type = "text/x-shellscript"
  etag   = filemd5("../EKS-dev.sh")
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
module "eks_cluster" {
  source = "./Modules/EKS"
  # Cluster Configuration
  cluster_name        = var.cluster_name
  kubernetes_version   = var.kubernetes_version
  cluster_role_arn    = module.iam_roles["cluster_role"].role_arn
  node_group_role_arn = module.iam_roles["nodegroup_role"].role_arn
  vpc_id              = module.VPC.vpc_id
  # Network Configuration
  subnet_ids         = module.VPC.private_subnet_ids
  private_subnet_ids = module.VPC.private_subnet_ids
  security_group_ids = [module.EKS_cluster_security_group.security_group_id]
  
  # Access Configuration
  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access  = var.endpoint_public_access


  # Node Group Configuration - On Demand
  desired_capacity_on_demand = var.desired_capacity_on_demand
  min_capacity_on_demand    = var.min_capacity_on_demand
  max_capacity_on_demand    = var.max_capacity_on_demand
  on_demand_instance_types  = var.on_demand_instance_types
  max_unavailable_on_demand = var.max_unavailable_on_demand

  # Node Group Configuration - Spot
  desired_capacity_spot = var.desired_capacity_spot
  min_capacity_spot    = var.min_capacity_spot
  max_capacity_spot    = var.max_capacity_spot
  spot_instance_types  = var.spot_instance_types

  # EKS Add-ons
  eks_addons = var.eks_addons

  # Tags
  environment = var.environment

  depends_on = [
    module.VPC,
    module.iam_roles,
    module.EKS_cluster_security_group
  ]
}

module "eks_access_entries" {
  source         = "./Modules/EKS-access-entry"
  cluster_name   = var.cluster_name
  access_entries = local.eks_cluster_access_entries 
}
# VPC and subnets 
variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "Public_subnets" {
  description = "Public subnets with CIDR blocks and availability zones"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "Private_subnets" {
  description = "Private subnets with CIDR blocks and availability zones"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "project_name" {
  type = string
  description = "The project name"
}

variable "region" {
  description = "region-name"
  type        = string
}

#############################################################################################
# SECURITY GROUPS VARIABLES
variable "common_ingress_rules" {
  description = "Common ingress rules applied to all security groups"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

# variable "Jenkins_ingress_rules" {
#   description = "ssh ingress rules for jenkins server in private subnet"
#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = list(string)
#   }))
# }


# extra port addition for main sg incase
variable "security_groups" {
  type = map(object({
    name        = string
    description = string
    extra_ports = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    tags = map(string)
  }))
}

################################################################################################
# IAM ROlES AND POLICIES
variable "iam_policies" {
  description = "A map of IAM policy configurations (excluding the document itself)."
  type = map(object({
    name        = string
    description = string
  }))
}

variable "iam_roles" {
  description = "Configuration for IAM roles."
  type = map(object({
    name              = string
    description       = string
    principal_type    = string
    principal_service = optional(string) # Needs to be optional here because it's null for IAM principals
    policy_arns       = list(string)
  }))
}

# IAM 
variable "developers_usernames" {
  description = "Map of developer users to create"
  type = list(string)
}

variable "admins_usernames" {
  description = "Map of admins users to create"
  type = list(string)
}
#################################################################################################
# EC2 
# Main server
variable "ami" {
  type = string
}

variable "instance_type" {
  type        = list(string)
  description = "List of possible EC2 instance types"
}

variable "key_name" {
  default = "private-key"
  type = string
}

variable "server_name" {
  type = string
  description = "EC2 server name"
}

variable "environment" {
  description = "The environment"
  type        = string
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
}

variable "root_volume_type" {
  description = "Type of the root EBS volume"
  type        = string
}

variable "delete_on_termination" {
  description = "Type of the root EBS volume"
  type        = bool
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to attach to the instance"
  type        = string
  default     = null
}
################################################################################################
# ECR
variable "ecr_repositories" {
  description = "Map of ECR repositories to create"
  type = map(object({
    name                 = string
    environment         = string
    image_tag_mutability = string
    scan_on_push        = bool
  }))
}


################################################################################################
# S3

variable "bucket_name" {
  description = "The name of the s3 bucket"
  type        = string
}


variable "bucket_description" {
  description = "s3 bucket description"
  type        = string
}

#########################################################################################################
# SSM
variable "name" {
  description = "Name of the SSM parameter"
  type        = string
}

variable "description" {
  description = "Description of the SSM parameter"
  type        = string
}

variable "type" {
  description = "Type of the SSM parameter (String, StringList, SecureString)"
  type        = string
}

# variable "value" {
#   description = "Value of the SSM parameter"
#   type        = string
# }

variable "tags" {
  description = "Tags to apply to the SSM parameter"
  type        = map(string)
  default     = {}
}

###############################################################################################################
# EKS Ccluster
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

# Node Group - On Demand Configuration
variable "desired_capacity_on_demand" {
  description = "Desired number of on-demand worker nodes"
  type        = number
}

variable "min_capacity_on_demand" {
  description = "Minimum number of on-demand worker nodes"
  type        = number
}

variable "max_capacity_on_demand" {
  description = "Maximum number of on-demand worker nodes"
  type        = number
}

variable "on_demand_instance_types" {
  description = "List of EC2 instance types for on-demand nodes"
  type        = list(string)
}

variable "max_unavailable_on_demand" {
  description = "Maximum number of on-demand nodes that can be unavailable during updates"
  type        = number
}

# Node Group - Spot Configuration
variable "desired_capacity_spot" {
  description = "Desired number of spot worker nodes"
  type        = number
}

variable "min_capacity_spot" {
  description = "Minimum number of spot worker nodes"
  type        = number
}

variable "max_capacity_spot" {
  description = "Maximum number of spot worker nodes"
  type        = number
}

variable "spot_instance_types" {
  description = "List of EC2 instance types for spot nodes"
  type        = list(string)
}

# EKS Add-ons Configuration
variable "eks_addons" {
  description = "Map of EKS add-ons to enable"
  type = map(object({
    version = string
  }))
}

# Access Configuration
variable "endpoint_private_access" {
  description = "Whether to enable private access to the EKS cluster endpoint"
  type        = bool
}

variable "endpoint_public_access" {
  description = "Whether to enable public access to the EKS cluster endpoint"
  type        = bool
}


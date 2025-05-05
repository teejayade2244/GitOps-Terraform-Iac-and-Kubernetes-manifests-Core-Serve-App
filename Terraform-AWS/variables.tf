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

################################################################################################
# ECR
variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
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
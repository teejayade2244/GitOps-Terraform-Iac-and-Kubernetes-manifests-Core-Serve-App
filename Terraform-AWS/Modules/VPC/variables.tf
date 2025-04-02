variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "project_name" {
  description = "Project name"
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

variable "environment" {
  description = "The environment"
  type        = string
}
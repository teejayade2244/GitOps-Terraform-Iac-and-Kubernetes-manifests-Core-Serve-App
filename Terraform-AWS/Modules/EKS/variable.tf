# Variables for EKS Cluster Module
# This module defines the variables required for creating an EKS cluster and its associated resources.
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.28"
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster (both public and private)"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for worker nodes"
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
}

variable "endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
}

variable "security_group_ids" {
  description = "List of security group IDs for the EKS cluster"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "node_group_role_arn" {
  description = "ARN of the IAM role for the EKS node group"
  type        = string
}


#############################################################################
# On-Demand Instance Configuration
variable "desired_capacity_on_demand" {
  description = "Desired number of on-demand worker nodes in the EKS node group"
  type        = number
}

variable "min_capacity_on_demand" {
  description = "Minimum number of on-demand worker nodes in the EKS node group"
  type        = number
}

variable "max_capacity_on_demand" {
  description = "Maximum number of on-demand worker nodes in the EKS node group"
  type        = number
}

variable "on_demand_instance_types" {
  description = "List of instance types for on-demand worker nodes"
  type        = list(string)
}
variable "max_unavailable_on_demand" {
  description = "Maximum number of unavailable on-demand worker nodes during an update"
  type        = number
}

variable "tags" {
  description = "Tags to apply to the EKS cluster and node group"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment for the EKS cluster"
  type        = string
}
############################################################################
# Spot Instance Configuration
variable "desired_capacity_spot" {
  description = "Desired number of spot worker nodes in the EKS node group"
  type        = number
}
variable "min_capacity_spot" {
  description = "Minimum number of spot worker nodes in the EKS node group"
  type        = number
}
variable "max_capacity_spot" {
  description = "Maximum number of spot worker nodes in the EKS node group"
  type        = number
}

variable "spot_instance_types" {
  type = list(string)
}

variable "eks_addons" {
  description = "Map of EKS add-ons to install"
  type = map(object({
    version : string
  }))

}
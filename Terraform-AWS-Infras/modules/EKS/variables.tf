variable "cluster_name" {
  description = "EKS Cluster Name"
  default     = "blackrose-eks"
}

variable "node_group_name" {
  description = "EKS Node Group Name"
  default     = "blackrose-node-group"
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Number of worker nodes"
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  default     = 3
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  default     = 1
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

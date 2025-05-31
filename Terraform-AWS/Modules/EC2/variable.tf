variable "ami" {
  description = "EC2 AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for main server"
  type        = string
}

variable "server_name" {
  description = "EC2 server name"
  type        = string
}

variable "subnet_id" {
  type = string
  description = "ID of the subnet where the instance will be created"
}

variable "security_group_id" {
  type = string
  description = "security group id"
}

variable "environment" {
  type = string
  description = "Environment"
}

variable "enable_provisioner" {
  type    = bool
  default = false   
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

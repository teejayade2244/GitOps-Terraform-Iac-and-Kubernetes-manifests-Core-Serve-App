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

variable "enable_provisioner" {
  type    = bool
  default = false   
}

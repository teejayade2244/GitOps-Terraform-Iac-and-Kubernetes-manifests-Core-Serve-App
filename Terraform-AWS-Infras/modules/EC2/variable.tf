variable "ami" {
  default = "ami-091f18e98bc129c4e"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type for Main server"
  default     = "t2.large"
}

variable "aws_security_group_main_Ec2_id" {
  description = "Security Group ID for main EC2"
}

variable "key_name" {
  default = "private-key"
  type = string
}

variable "server_name" {
  default = "Main-EC2-Server"
  type = string
}
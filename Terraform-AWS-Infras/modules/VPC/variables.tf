variable "cidr_block" {
  default = "10.0.0.0/16"
  type = string
}

variable "Public_subnets" {
  default = {
    publicSubnet1  = { cidr = "10.0.1.0/24", az = "eu-west-2a" }
    publicSubnet2  = { cidr = "10.0.2.0/24", az = "us-east-2b" }
  }
}

variable "Private_subnets" {
  default = {
    privateSubnet1 = { cidr = "10.0.3.0/24", az = "eu-west-2a" }
    privateSubnet2 = { cidr = "10.0.4.0/24", az = "us-east-2b" }
  }
}

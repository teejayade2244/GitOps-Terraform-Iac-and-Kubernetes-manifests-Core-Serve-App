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

variable "value" {
  description = "Value of the SSM parameter"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the SSM parameter"
  type        = map(string)
  default     = {}
}
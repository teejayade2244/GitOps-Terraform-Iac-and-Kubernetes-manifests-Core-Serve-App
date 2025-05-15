variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
}

variable "policy_description" {
  description = "Description of the IAM policy"
  type        = string
  default     = ""
}

variable "policy_document" {
  description = "JSON policy document"
  type        = string
}

variable "attach_to_roles" {
  description = "List of IAM role names to attach this policy to"
  type        = list(string)
  default     = []
}
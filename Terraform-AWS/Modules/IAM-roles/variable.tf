variable "role_name" {
  type        = string
  description = "The name of the IAM role"
}

variable "role_description" {
  type        = string
  default     = ""
  description = "Description of the IAM role"
}

variable "assume_role_policy" {
  type        = string
  description = "Trust relationship in JSON"
}

variable "policy_arns" {
  type        = list(string)
  description = "List of IAM policy ARNs to attach"
}


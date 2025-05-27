variable "group_name" {
  description = "Name of the IAM group"
  type        = string
}

variable "group_path" {
  description = "Path to the IAM group"
  type        = string
  default     = "/"
}

variable "user_names" {
  description = "List of IAM users to add to the group"
  type        = list(string)
  default     = []
}

variable "policy_arns" {
  description = "List of IAM policy ARNs to attach to the group"
  type        = list(string)
  default     = []
}
variable "group_name" {
  description = "Name of the IAM group"
  type        = string
}

variable "path" {
  description = "Path in which to create the group"
  type        = string
  default     = "/"
}

variable "usernames" {
  description = "List of IAM usernames to add to the group"
  type        = list(string)
  default     = []
}

variable "policy_arns" {
  description = "List of IAM policy ARNs to attach to the group"
  type        = list(string)
  default     = []
}
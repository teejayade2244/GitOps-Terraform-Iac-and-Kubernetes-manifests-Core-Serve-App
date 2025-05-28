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

variable "create_instance_profile" {
  description = "Whether to create an instance profile"
  type        = bool
  default     = true
}

variable "principal_type" {
  description = "Type of principal that can assume this role (Service or IAM)."
  type        = string
}

variable "principal_service" {
  description = "Service principal for assume role policy (e.g., ec2.amazonaws.com). Required if principal_type is 'Service'."
  type        = string
  default     = null # Make it optional
}

variable "principal_arns" {
  description = "List of IAM User/Role ARNs that can assume this role. Required if principal_type is 'IAM'."
  type        = list(string)
  default     = [] # Make it optional and default to empty
}
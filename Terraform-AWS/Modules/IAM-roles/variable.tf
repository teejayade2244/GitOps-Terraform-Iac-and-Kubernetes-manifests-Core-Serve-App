
variable "role_name" {
  description = "The name of the IAM role."
  type        = string
}

variable "role_description" {
  description = "The description of the IAM role."
  type        = string
  default     = ""
}

# Define assume_role_policy as a string variable
variable "assume_role_policy" {
  description = "The policy that grants an entity permission to assume the role (as a JSON string)."
  type        = string
}

variable "policy_arns" {
  description = "A list of IAM policy ARNs to attach to the role."
  type        = list(string)
  default     = []
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile for this role."
  type        = bool
  default     = false # Set a default if it's not always passed
}
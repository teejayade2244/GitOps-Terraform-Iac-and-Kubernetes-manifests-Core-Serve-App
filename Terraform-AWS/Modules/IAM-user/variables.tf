variable "user_name" {
  description = "Name of the IAM user"
  type        = string
}

variable "path" {
  description = "Path in which to create the user"
  type        = string
  default     = "/"
}

variable "create_login_profile" {
  description = "Whether to create IAM user login profile"
  type        = bool
  default     = false
}

variable "create_access_key" {
  description = "Whether to create IAM access key"
  type        = bool
  default     = true
}

variable "pgp_key" {
  description = "PGP key used to encrypt password"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the user"
  type        = map(string)
  default     = {}
}
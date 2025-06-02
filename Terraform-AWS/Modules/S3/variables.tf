variable "bucket_name" {
  type = string
  description = "Specifies the bucket name to be created"
}

variable "bucket_description" {
  type = string
  description = "bucket description"
}

variable "versioning" {
  type        = bool
  description = "Enable versioning for the bucket"
  default     = false
}

variable "encryption" {
  type        = bool
  description = "Enable encryption for the bucket"
  default     = true
}

variable "force_destroy" {
  type        = bool
  description = "Allow destruction of non-empty bucket"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the bucket"
  default     = {}
}
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "environment" {
  description = "Environment tag for the repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Enable scan on push for the repository"
  type        = bool
  default     = true
}
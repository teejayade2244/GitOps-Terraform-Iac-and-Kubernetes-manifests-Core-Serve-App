variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "environment" {
  description = "Environment (e.g. dev, prod, staging)"
  type        = string
}
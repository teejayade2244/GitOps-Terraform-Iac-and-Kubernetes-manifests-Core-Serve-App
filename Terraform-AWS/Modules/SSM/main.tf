# This resource creates an SSM parameter in AWS Systems Manager Parameter Store
resource "aws_ssm_parameter" "terraform_tfvars" {
  name        = var.name  # SSM parameter path
  description = var.description
  type        = var.type
  value       = var.value
  tags = var.tags
}

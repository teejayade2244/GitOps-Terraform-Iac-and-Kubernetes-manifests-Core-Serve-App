# This resource creates an SSM parameter in AWS Systems Manager Parameter Store
resource "aws_ssm_parameter" "terraform_tfvars" {
  name        = "/core-serve/dev/dev.tfvars"  # SSM parameter path
  description = "Terraform variables for dev environment"
  type        = "SecureString"                   # Encrypted at rest
  value       = file("../../dev.tfvars")  # Reads local .tfvars file
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
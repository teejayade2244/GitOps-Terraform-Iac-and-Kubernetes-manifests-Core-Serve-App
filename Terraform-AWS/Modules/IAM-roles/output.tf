# ./Modules/IAM/outputs.tf
output "role_arn" {
  value       = aws_iam_role.iam_role.arn
  description = "The ARN of the IAM role"
}

output "role_name" {
  value       = aws_iam_role.iam_role.name
  description = "The name of the IAM role"
}

output "policy_arn" {
  description = "ARN of the created IAM policy"
  value       = aws_iam_policy.policy.arn
}

output "policy_name" {
  description = "Name of the created IAM policy"
  value       = aws_iam_policy.policy.name
}
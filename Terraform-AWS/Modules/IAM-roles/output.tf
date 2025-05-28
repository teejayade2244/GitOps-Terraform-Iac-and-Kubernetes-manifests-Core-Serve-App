
output "role_arn" {
  value       = aws_iam_role.iam_role.arn
  description = "The ARN of the IAM role"
}

output "role_name" {
  value       = aws_iam_role.iam_role.name
  description = "The name of the IAM role"
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.instance_profile[0].name
}

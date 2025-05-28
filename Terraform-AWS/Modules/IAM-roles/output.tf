
output "role_arn" {
  value       = aws_iam_role.iam_role.arn
  description = "The ARN of the IAM role"
}

output "role_name" {
  value       = aws_iam_role.iam_role.name
  description = "The name of the IAM role"
}


output "instance_profile_name" {
  description = "The name of the IAM instance profile, if created."
  # Use a conditional expression to only get the name if the instance profile exists.
  # If length is 0, it means it wasn't created, so return null.
  value       = length(aws_iam_instance_profile.instance_profile) > 0 ? aws_iam_instance_profile.instance_profile[0].name : null
}

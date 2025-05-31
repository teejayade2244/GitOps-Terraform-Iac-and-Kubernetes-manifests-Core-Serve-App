output "group_name" {
  description = "Name of the IAM group"
  value       = aws_iam_group.main.name
}

output "group_arn" {
  description = "ARN of the IAM group"
  value       = aws_iam_group.main.arn
}

output "group_id" {
  description = "ID of the IAM group"
  value       = aws_iam_group.main.id
}
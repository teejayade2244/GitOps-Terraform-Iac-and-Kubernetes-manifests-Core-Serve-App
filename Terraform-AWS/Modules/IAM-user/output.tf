output "user_name" {
  value = aws_iam_user.user.name
}

output "user_arn" {
  value = aws_iam_user.user.arn
}

output "access_key_id" {
  value = try(aws_iam_access_key.key[0].id, "")
}

output "secret_access_key" {
  value     = try(aws_iam_access_key.key[0].secret, "")
  sensitive = true
}
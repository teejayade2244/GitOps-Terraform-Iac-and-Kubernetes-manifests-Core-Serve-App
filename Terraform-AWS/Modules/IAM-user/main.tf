resource "aws_iam_user" "user" {
  name = var.user_name
  path = var.path
  tags = var.tags
}

resource "aws_iam_user_login_profile" "profile" {
  count                   = var.create_login_profile ? 1 : 0
  user                    = aws_iam_user.user.name
  password_reset_required = true
  pgp_key                = var.pgp_key
}

resource "aws_iam_access_key" "key" {
  count = var.create_access_key ? 1 : 0
  user  = aws_iam_user.user.name
}
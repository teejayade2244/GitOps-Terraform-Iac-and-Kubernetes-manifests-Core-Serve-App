resource "aws_iam_role" "iam_role" {
  name               = var.role_name
  description        = var.role_description
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  for_each = toset(var.policy_arns)
  policy_arn = each.value
  role       = aws_iam_role.iam_role.name
}


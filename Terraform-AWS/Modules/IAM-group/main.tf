# IAM Group
resource "aws_iam_group" "this" {
  name = var.group_name
  path = var.group_path
}

# IAM Group Membership
resource "aws_iam_group_membership" "this" {
  name  = "${var.group_name}-membership"
  group = aws_iam_group.this.name
  users = var.user_names
}

# IAM Group Policy Attachment
resource "aws_iam_group_policy_attachment" "this" {
  for_each   = toset(var.policy_arns)
  group      = aws_iam_group.this.name
  policy_arn = each.value
}
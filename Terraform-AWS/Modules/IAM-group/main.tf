# IAM Group
resource "aws_iam_group" "this" {
  name = var.group_name
  path = var.path
}

# IAM Group Membership
resource "aws_iam_group_membership" "this" {
  count = length(var.usernames) > 0 ? 1 : 0
  name  = "${var.group_name}-membership"
  users = var.usernames
  group = aws_iam_group.this.name
}

# IAM Group Policy Attachment
resource "aws_iam_group_policy_attachment" "this" {
  for_each = { for idx, arn in var.policy_arns : idx => arn }
  
  group      = aws_iam_group.this.name
  policy_arn = each.value
}
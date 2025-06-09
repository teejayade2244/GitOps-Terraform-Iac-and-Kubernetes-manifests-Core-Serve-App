# IAM Group
resource "aws_iam_group" "main" {
  name = var.group_name
  path = var.group_path
}

# IAM Group Membership
resource "aws_iam_group_membership" "group_membership" {
  name  = "${var.group_name}-membership"
  group = aws_iam_group.main.name
  users = var.user_names
}

# IAM Group Policy Attachment
resource "aws_iam_group_policy_attachment" "group_policy_attachment" {
  count      = length(var.policy_arns) 
  group      = aws_iam_group.main.name
  policy_arn = var.policy_arns[count.index] 
}
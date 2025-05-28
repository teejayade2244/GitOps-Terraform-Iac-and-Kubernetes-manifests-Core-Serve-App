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
  # CHANGE THIS LINE:
  count      = length(var.policy_arns) # Use 'count' based on the number of ARNs passed in the list
  group      = aws_iam_group.this.name
  policy_arn = var.policy_arns[count.index] # Access each ARN by its index in the list
}
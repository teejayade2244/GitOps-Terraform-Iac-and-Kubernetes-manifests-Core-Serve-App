# Modules/IAM-roles/main.tf (Your provided code, with added outputs and tags)

resource "aws_iam_role" "iam_role" {
  name               = var.role_name
  description        = var.role_description
  assume_role_policy = var.assume_role_policy # This is correct

  tags = { # Consider adding tags for better resource management
    Name = var.role_name
    # Add other common tags if needed, e.g., Environment = var.environment if passed as a variable
  }
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count      = length(var.policy_arns)
  policy_arn = var.policy_arns[count.index]
  role       = aws_iam_role.iam_role.name
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = var.create_instance_profile ? 1 : 0 # Uses the variable passed from root/main.tf
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.iam_role.name
}


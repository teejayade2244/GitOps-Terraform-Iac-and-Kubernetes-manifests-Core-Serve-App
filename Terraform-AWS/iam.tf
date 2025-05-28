# Create the roles
resource "aws_iam_role" "eks_roles" {
  for_each = var.eks_roles
  name               = each.value.name
  description        = each.value.description
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = each.value.principal_service
        }
      }
    ]
  })
}

# Attach managed AWS policies
resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = {
    for combo in flatten([
      for role_key, role in var.eks_roles : [
        for policy_arn in role.managed_policy_arns : {
          key        = "${role_key}-${basename(policy_arn)}"
          role_name  = role.name
          policy_arn = policy_arn
        }
      ]
    ]) : combo.key => combo
  }
  
  role       = aws_iam_role.eks_roles[split("-", each.key)[0]].name
  policy_arn = each.value.policy_arn
}

# Attach custom policies (created by your iam_policies module)
resource "aws_iam_role_policy_attachment" "custom_policies" {
  for_each = {
    for combo in flatten([
      for role_key, role in var.eks_roles : [
        for policy_key in try(role.custom_policies, []) : {
          key        = "${role_key}-${policy_key}"
          role_key   = role_key
          policy_key = policy_key
        }
      ]
    ]) : combo.key => combo
  }
  
  role       = aws_iam_role.eks_roles[each.value.role_key].name
  policy_arn = module.iam_policies[each.value.policy_key].policy_arn
}
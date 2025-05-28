resource "aws_iam_policy" "custom_policies" {
  for_each = var.iam_policies
  
  name        = each.value.name
  description = each.value.description
  policy      = each.value.document
}

# iam.tf - Simplified
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
        for policy_arn in role.policy_arns : {
          key        = "${role_key}-${basename(policy_arn)}"
          role_key   = role_key
          policy_arn = policy_arn
        }
      ]
    ]) : combo.key => combo
  }
  
  role       = aws_iam_role.eks_roles[each.value.role_key].name
  policy_arn = each.value.policy_arn
}

# Attach custom policies
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
  policy_arn = aws_iam_policy.custom_policies[each.value.policy_key].arn
}
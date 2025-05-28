# Policy attachments for managed AWS policies
resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = {
    for pair in flatten([
      for role_name, role in var.eks_roles : [
        for policy_arn in role.policy_arns : {  # Changed from managed_policy_arns
          role_name  = role_name
          policy_arn = policy_arn
        }
      ]
    ]) : "${pair.role_name}-${pair.policy_arn}" => pair
  }

  role       = module.eks_iam_roles[each.value.role_name].role_name
  policy_arn = each.value.policy_arn
}

# Policy attachments for custom policies
resource "aws_iam_role_policy_attachment" "custom_policies" {
  for_each = {
    for pair in flatten([
      for role_name, role in var.eks_roles : [
        for policy_name in role.custom_policies : {
          role_name    = role_name
          policy_name  = policy_name
        }
      ]
    ]) : "${pair.role_name}-${pair.policy_name}" => pair
  }

  role       = module.eks_iam_roles[each.value.role_name].role_name
  policy_arn = module.iam_policies[each.value.policy_name].policy_arn
}
resource "aws_eks_access_entry" "this" {
  for_each          = var.access_entries 
  cluster_name      = var.cluster_name
  principal_arn     = each.value.principal_arn
  kubernetes_groups = each.value.kubernetes_groups
  type              = each.value.type
}
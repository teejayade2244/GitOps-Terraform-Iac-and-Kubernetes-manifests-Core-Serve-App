locals {
  # Define IAM policy documents for different roles
  iam_policy_documents = {
    jenkins       = data.aws_iam_policy_document.jenkins.json
    eks_developer = data.aws_iam_policy_document.eks_developer.json
    eks_admin     = data.aws_iam_policy_document.eks_admin.json
  }


  eks_cluster_access_entries = {
    # Admin access: map EKS admin role to Kubernetes system:masters group
    # eks_admin_access_entry = {
    #   principal_arn     = module.iam_roles["admin_role"].role_arn
    #   kubernetes_groups = ["admin-group"]
    #   # type defaults to "STANDARD" as per variable definition
    # },
    # # DevOps access: map EKS devops role to a custom 'devops-team' Kubernetes group
    # eks_developers_access_entry = {
    #   principal_arn     = module.iam_roles["developer_role"].role_arn
    #   kubernetes_groups = ["resource-viewer"]
    # },
    dev1_iam_user_access_entry = {
      principal_arn     = module.admins["dev1"].arn # <--- This gets the ARN of the 'dev1' IAM user
      kubernetes_groups = ["resource-viewer"]        # <--- Granting 'system:masters' for full admin access
                                                    #      (for testing; you might want a more restricted group later)
      # type defaults to "STANDARD"
    }
  }
}
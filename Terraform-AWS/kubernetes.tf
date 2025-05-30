resource "aws_iam_policy" "ecr_pull_policy" {
  name        = "core-serve-ecr-pull-policy"
  description = "Policy to allow pulling images from ECR"
  policy      = data.aws_iam_policy_document.ecr_pull_policy.json
}

resource "aws_iam_role" "ecr_pull_role" {
  name               = "core-serve-ecr-pull-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(module.eks_cluster.cluster_oidc_issuer_url, "https://", "")}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(module.eks_cluster.cluster_oidc_issuer_url, "https://", "")}:sub" : "system:serviceaccount:my-namespace:core-serve-service-account"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_pull_attachment" {
  role       = aws_iam_role.ecr_pull_role.name
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
}

# Define your Kubernetes Service Account (using `kubernetes_service_account` resource or helm chart values)
resource "kubernetes_service_account_v1" "core_serve_sa" {
  metadata {
    name      = "core-serve-service-account"
    namespace = "core-serve" 
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ecr_pull_role.arn
    }
  }
}
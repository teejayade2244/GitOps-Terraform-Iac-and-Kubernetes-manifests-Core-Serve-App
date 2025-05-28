# This file contains the IAM policies for various roles in the AWS environment.
data "aws_iam_policy_document" "jenkins" {
  statement {
    effect = "Allow"
    actions = ["ec2:Describe*", "ec2:StartInstances", "ec2:CreateTags", "ec2:RunInstances"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = ["s3:GetObject", "s3:PutObject"]
    resources = [
      "arn:aws:s3:::jenkins-build-reports-core-serve-frontend/*",
      "arn:aws:s3:::terraform-state-core-serve-app/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = ["ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "ecr:PutImage", "ecr:GetAuthorizationToken", "ecr:InitiateLayerUpload", "ecr:UploadLayerPart", "ecr:CompleteLayerUpload"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "eks_developer" {
  statement {
    sid       = "ListAndDescribeEKS"
    effect    = "Allow"
    actions   = ["eks:ListClusters", "eks:DescribeCluster"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "eks_admin" {
  statement {
    sid       = "EKSFullAccess"
    effect    = "Allow"
    actions   = ["eks:*"]
    resources = ["*"]
  }
}
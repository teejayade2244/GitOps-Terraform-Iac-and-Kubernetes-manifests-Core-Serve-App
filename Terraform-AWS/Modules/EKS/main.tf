# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

    vpc_config {
      subnet_ids              = var.subnet_ids
      # List of subnet IDs where the EKS cluster will be created.
      endpoint_private_access = var.endpoint_private_access
      # If true, it allows private access to the Kubernetes API (from within your VPC).
      endpoint_public_access  = var.endpoint_public_access
      # If true, it allows public access to the Kubernetes API (from the internet).
      security_group_ids      = var.security_group_ids
      # security groups that will be associated with the EKS cluster.
    }

     # This block is used to configure the access to the EKS cluster.
     # It allows you to specify the authentication mode and whether the bootstrap cluster creator has admin permissions.
    access_config {
       authentication_mode = "API"
       bootstrap_cluster_creator_admin_permissions = true
    } 
}


# EKS Node Group
resource "aws_eks_node_group" "on_demand" {
  # This node group is configured to use on-demand instances.
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-on-demand-nodes"
  node_role_arn   = var.node_group_role_arn 
  subnet_ids      = var.private_subnet_ids
  version  = var.kubernetes_version

  # Scaling configuration
  scaling_config {
    desired_size = var.desired_capacity_on_demand
    min_size     = var.min_capacity_on_demand
    max_size     = var.max_capacity_on_demand
  }

  instance_types = var.on_demand_instance_types
  capacity_type  = "ON_DEMAND"

  labels = {
    "role" = "on-demand-nodes"
  }
  
  # Controls how many nodes can be unavailable during an update (e.g., AMI updates).
  update_config {
    max_unavailable = var.max_unavailable_on_demand
  }
  tags = {
    "Name" = "${var.cluster_name}-on-demand-nodes"
    environment = var.environment
  }

  depends_on = [aws_eks_cluster.eks]
}

# EKS Spot Node Group
# This node group is configured to use spot instances for cost savings.
resource "aws_eks_node_group" "spot" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-spot-nodes"
  node_role_arn   = var.node_group_role_arn
  subnet_ids      = var.private_subnet_ids
  version         = var.kubernetes_version

  scaling_config {
    desired_size = var.desired_capacity_spot
    min_size     = var.min_capacity_spot
    max_size     = var.max_capacity_spot
  }

  instance_types = var.spot_instance_types
  capacity_type  = "SPOT"

  labels = {
    "role" = "spot-nodes"
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    "Name" = "${var.cluster_name}-spot-nodes"
    environment = var.environment
  }

  depends_on = [aws_eks_cluster.eks]
}


# OIDC Thumbprint Data Source
# This data source retrieves the OIDC thumbprint for the EKS cluster's OIDC provider.
data "tls_certificate" "eks_oidc_thumbprint" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}
# OIDC Provider for EKS
# This resource creates an OpenID Connect (OIDC) provider for the EKS cluster.
# The OIDC provider allows Kubernetes pods (via service accounts) to assume IAM roles
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc_thumbprint.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# EKS Addons
# This resource manages EKS addons, which are additional components that can be installed on the EKS cluster.
resource "aws_eks_addon" "addons" {
  for_each = var.eks_addons
  cluster_name = aws_eks_cluster.main.name
  addon_name   = each.key
  addon_version = each.value.version
  depends_on = [
    aws_eks_node_group.on_demand,
    aws_eks_node_group.spot
  ]
}

resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256" 
  }

  tags = {
    Name        = var.repository_name
    Environment = var.environment
    Managed_by  = "Terraform"
  }
}

# Optional lifecycle policy
resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr_repo.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 30 images"
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 30
      }
      action = {
        type = "expire"
      }
    }]
  })
}
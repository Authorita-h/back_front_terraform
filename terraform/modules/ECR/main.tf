resource "aws_ecr_repository" "ecr_frontend_repository" {
  name = "frontend-repository"

  tags = {
      "Name" = "ECR frontend repository"
      "Environment" = local.workspace
  }
}

resource "aws_ecr_repository" "ecr_backend_repository" {
  name = "backend-repository"

  tags = {
      "Name" = "ECR backend repository"
  }
}
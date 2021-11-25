resource "aws_ecr_repository" "ecr_frontend_repository" {
  name = "${local.workspace}-frontend-repository"

  tags = {
      "Name" = "ECR frontend repository for ${local.workspace}"
      "Environment" = local.workspace
  }
}

resource "aws_ecr_repository" "ecr_backend_repository" {
  name = "${local.workspace}-backend-repository"

  tags = {
      "Name" = "ECR backend repository for ${local.workspace}"
      "Environment" = local.workspace
  }
}
provider "aws" {
  region = "eu-central-1"
}

# terraform {
#   backend "s3" {
#     bucket = "remote-state.bucket"
#     key    = "infrastructure/terraform.tfstate"
#     region = "eu-central-1"
#   }
# }

module "rds_database" {
  source      = "./modules/RDS"
  DB_NAME     = var.DB_NAME
  DB_USERNAME = var.DB_USERNAME
  DB_PASSWORD = var.DB_PASSWORD
}

module "ecs_cluster" {
  source = "./modules/ECS"
  frontend_repository_url = var.frontend_repository_url
  backend_repository_url = var.backend_repository_url
  depends_on = [
    module.rds_database
  ]
  DB_HOST = module.rds_database.rds_endpoint_address.endpoint
}
provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "remote-state.bucket"
    key    = "infrastructure/terraform.tfstate"
    region = "eu-central-1"
  }
}

  module "load_balancer" {
    source = "./modules/LB" 
    frontend_port = var.frontend_port
    backend_port = var.backend_port
  }

module "rds_database" {
  source      = "./modules/RDS"
  DB_NAME     = var.DB_NAME
  DB_USERNAME = var.DB_USERNAME
  DB_PASSWORD = var.DB_PASSWORD
  # frontend_port = var.frontend_port
  # backend_port = var.backend_port
}

module "ecs_cluster" {
  source = "./modules/ECS"
  frontend_repository_url = var.frontend_repository_url
  backend_repository_url = var.backend_repository_url
  depends_on = [
    module.rds_database
  ]
  DB_HOST = module.rds_database.rds_endpoint_address.address
  DB_NAME           = var.DB_NAME
  DB_USERNAME       = var.DB_USERNAME
  DB_PASSWORD       = var.DB_PASSWORD
  GOOGLE_CLIENT_ID    = var.GOOGLE_CLIENT_ID
  GOOGLE_CLIENT_SECRET  = var.GOOGLE_CLIENT_SECRET
  frontend_target_group = module.load_balancer.frontend_target_group.arn
  backend_target_group = module.load_balancer.backend_lb_target_group.arn
  frontend_port = var.frontend_port
  backend_port = var.backend_port
  site_domain = module.load_balancer.load_balancer.dns_name
}

module "route53" {
  source = "./modules/Route53"
  site_domain = var.site_domain
  load_balancer_name = module.load_balancer.load_balancer.dns_name
  load_balancer_zone_id = module.load_balancer.load_balancer.zone_id
}
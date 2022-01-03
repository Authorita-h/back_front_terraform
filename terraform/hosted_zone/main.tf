provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "remote-state.bucket"
    key    = "hosted_zone/terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_route53_zone" "route53_zone" {
  name = var.site_domain
}

module "repositories" {
  source = "../modules/ECR"
}

module "certificate" {
  source = "../modules/certificate"
  site_domain = var.site_domain
  depends_on = [
    aws_route53_zone.route53_zone
  ]
}
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


locals {
  workspace = terraform.workspace
}

variable "site_domain" {
  type = string
}

variable "load_balancer_name" {
  type = string
}

variable "load_balancer_zone_id" {
  type = string
}
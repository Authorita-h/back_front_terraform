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

# variable "zone_id" {
#   type = string
# }
# variable "cert_record" {
#   type = string
# }

# variable "cert_value" {
#   type = string
# }
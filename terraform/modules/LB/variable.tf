locals {
  workspace = terraform.workspace  
}

# variable "frontend_service_id" {
#   type = string
# }

# variable "backend_service_id" {
#   type = string
# }

variable "frontend_port" {
  type = number
  default = 80
}

variable "backend_port" {
  type = number
}

variable "site_domain" {
  type = string
}

variable "cert_arn" {
  type = string
}
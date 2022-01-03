variable "backend_repository_url" {
  type = string
  default = data.terraform_remote_state.remote_state.outputs.ecr_backend
}

variable "backend_repository_url" {
  type = string
  default = data.terraform_remote_state.remote_state.outputs.ecr_frontend
}

variable "frontend_repository_url" {
  type = string
}

variable "DB_NAME" {
  type = string
}

variable "DB_PASSWORD" {
  type = string
}

variable "DB_USERNAME" {
  type = string
}

variable "GOOGLE_CLIENT_ID" {
  type = string
}

variable "GOOGLE_CLIENT_SECRET" {
  type = string
}

variable "frontend_port" {
  type = number
  default = 8080
}

variable "backend_port" {
  type = number
  default = 3000
}

variable "site_domain" {
  type = string
}

variable "cert_arn" {
  type = string
}

# variable "backend_hostname" {
#   type = string
# }
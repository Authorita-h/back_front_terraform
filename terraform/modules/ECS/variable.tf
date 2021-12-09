locals {
  workspace = terraform.workspace
}

variable "instance_type" {
  type = string
  default = "t3a.medium"
}

variable "max_instances" {
  type = number
  default = 1
}

variable "min_instances" {
  type = number
  default = 1
}

variable "desired_instances" {
  type = number
  default = 1
}

variable "frontend_repository_url" {
  type = string
}

variable "backend_repository_url" {
  type = string
}

variable "template_dir_path" {
  type = string
  default = "templates/"
}

variable "task_count" {
  type = number
  default = 1
}

variable "DB_HOST" {
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

variable "frontend_target_group" {
  type = string
}

variable "backend_target_group" {
  type = string
}

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

# variable "backend_hostname" {
#   type = string
# }
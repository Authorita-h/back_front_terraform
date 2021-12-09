locals {
  workspace = terraform.workspace
}

variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_engine_version" {
  type    = string
  default = "12"
}

variable "db_instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 10
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

# variable "frontend_port" {
#   type = number
#   default = 80
# }

# variable "backend_port" {
#   type = number
# }

variable "DB_PORT" {
  type = number
  default = 5432
}
locals {
  workspace = terraform.workspace
}

variable "instance_type" {
  type = string
  default = "t2.micro"
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

# variable "ecs_cluster_id" {
  
# }

# variable "ecs_task_defenition_arn" {
  
# }
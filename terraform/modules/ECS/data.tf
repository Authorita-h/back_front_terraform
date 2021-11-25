data "aws_availability_zones" "az" {}

data "aws_vpc" "vpc" {
  default = true
}

data "aws_ami" "ami_latest_amazon" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

data "template_file" "ecr_frontend_image_path" {
  template = file("${var.template_dir_path}/frontend_task_defenition.json.tpl")
  vars = {
    workspace             = local.workspace
    image_repository_path = var.frontend_repository_url
  }
}

data "template_file" "ecr_backend_image_path" {
  template = file("${var.template_dir_path}/backend_task_defenition.json.tpl")
  vars = {
    workspace             = local.workspace
    image_repository_path = var.backend_repository_url
    database_host         = var.DB_HOST
  }
}


data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
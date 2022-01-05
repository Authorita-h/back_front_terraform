resource "aws_ecs_task_definition" "ecs_frontend_task_defenition" {
  family                = "${local.workspace}-frontend-service"
  network_mode          = "awsvpc"
  container_definitions = data.template_file.ecr_frontend_image_path.rendered
}

resource "aws_ecs_task_definition" "ecs_backend_task_defenition" {
  family                = "${local.workspace}-backend-service"
  network_mode          = "awsvpc"
  container_definitions = data.template_file.ecr_backend_image_path.rendered
}

resource "aws_ecs_service" "frontend_service" {
  name            = "${local.workspace}-frontend-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ecs_frontend_task_defenition.arn
  desired_count   = var.task_count
  deployment_maximum_percent = var.deployment_maximum_healthy_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  network_configuration {
    security_groups  = [var.cluster_sg_id]
    subnets          = data.aws_subnet_ids.subnet_ids.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.frontend_target_group
    container_name   = "${local.workspace}-frontend-service"
    container_port   = var.frontend_port
  }
}

resource "aws_ecs_service" "backend_service" {
  name            = "${local.workspace}-backend-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ecs_backend_task_defenition.arn
  desired_count   = var.task_count
  deployment_maximum_percent = var.deployment_maximum_healthy_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  network_configuration {
    security_groups  = [var.cluster_sg_id]
    subnets          = data.aws_subnet_ids.subnet_ids.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.backend_target_group
    container_name   = "${local.workspace}-backend-service"
    container_port   = var.backend_port
  }
}

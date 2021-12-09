resource "aws_security_group" "new_security_group" {
  name        = "${local.workspace}-cluster-security-group"
  description = "HTTP"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = var.frontend_port
    to_port     = var.frontend_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.backend_port
    to_port     = var.backend_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.workspace}-cluster"
}

resource "aws_launch_configuration" "new_launch_configuration" {
  name                        = "${local.workspace}-launch-configuration"
  associate_public_ip_address = true
  image_id                    = data.aws_ami.ami_latest_amazon.id
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.new_security_group.id]
  user_data                   = <<EOT
    #!/bin/bash
    echo ECS_CLUSTER=${local.workspace}-cluster >> /etc/ecs/ecs.config
  EOT
}

resource "aws_autoscaling_group" "new_asg" {
  name                 = "${local.workspace}-autoscaling-group"
  max_size             = var.max_instances
  min_size             = var.min_instances
  desired_capacity     = var.desired_instances
  launch_configuration = aws_launch_configuration.new_launch_configuration.name
  availability_zones   = data.aws_availability_zones.az.names
}

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

resource "aws_iam_role" "ecs_agent" {
  name               = "${local.workspace}-ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "${local.workspace}-ecs-agent"
  role = aws_iam_role.ecs_agent.name
}

resource "aws_ecs_service" "frontend_service" {
  name            = "${local.workspace}-frontend-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_frontend_task_defenition.arn
  desired_count   = var.task_count

  network_configuration {
    security_groups  = [aws_security_group.new_security_group.id]
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
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_backend_task_defenition.arn
  desired_count   = var.task_count

  network_configuration {
    security_groups  = [aws_security_group.new_security_group.id]
    subnets          = data.aws_subnet_ids.subnet_ids.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.backend_target_group
    container_name   = "${local.workspace}-backend-service"
    container_port   = var.backend_port
  }
}

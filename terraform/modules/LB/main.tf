resource "aws_security_group" "lb_security_group" {
  name        = "${local.workspace}-lb-security-group"
  description = "HTTP"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_lb" "application_load_balancer" {
  name = local.workspace
  load_balancer_type = "application"
  security_groups = [ aws_security_group.lb_security_group.id ]
  subnets = data.aws_subnet_ids.subnet_ids.ids
}  

resource "aws_lb_target_group" "frontend_lb_target_group" {
  name = "${local.workspace}-frontend-target-group"
  target_type = "ip"
  protocol = "HTTP"
  port = var.frontend_port
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_lb_target_group" "backend_lb_target_group" {
  name = "${local.workspace}-backend-target-group"
  target_type = "ip"
  protocol = "HTTP"
  port = var.backend_port
  vpc_id = data.aws_vpc.vpc.id

  health_check {
    healthy_threshold = 2
    interval = 50
    timeout = 40
  }
}

resource "aws_lb_listener" "frontend_lb_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port = var.frontend_port

  default_action {
    target_group_arn = aws_lb_target_group.frontend_lb_target_group.arn
    type = "forward"
  }
}

resource "aws_lb_listener" "backend_lb_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port = var.backend_port

  default_action {
    target_group_arn = aws_lb_target_group.backend_lb_target_group.arn
    type = "forward"
  }
}

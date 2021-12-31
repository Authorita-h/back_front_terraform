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

  # ingress {
  #   from_port   = var.frontend_port
  #   to_port     = var.frontend_port
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port   = var.backend_port
  #   to_port     = var.backend_port
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

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
    path = "/docs"
    matcher = "401,200"
    healthy_threshold = 3
    interval = 80
    timeout = 60
  }
}

resource "aws_lb_listener" "frontend_lb_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port = 443
  protocol = "HTTPS"
  certificate_arn = aws_acm_certificate.cert.arn

  default_action {
    target_group_arn = aws_lb_target_group.frontend_lb_target_group.arn
    type = "forward"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "backend_lb_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port = 3000

  default_action {
    target_group_arn = aws_lb_target_group.backend_lb_target_group.arn
    type = "forward"
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.frontend_lb_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_lb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/docs/"]
    }
  }

  condition {
    host_header {
      values = ["aws-test.ml"]
    }
  }
}

resource "aws_lb_listener_rule" "api_forward" {
  listener_arn = aws_lb_listener.frontend_lb_listener.arn
  priority     = local.workspace == "prod" ? 200 : 100
  count = local.workspace == "prod" ? 1 : 0

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_lb_target_group.arn
  }

  condition {
    host_header {
      values = ["api.${var.site_domain}"]
    }
  }
}

resource "aws_lb_listener_rule" "api_workspace_forward" {
  listener_arn = aws_lb_listener.frontend_lb_listener.arn
  priority     = 101
  count = local.workspace == "prod" ? 0 : 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_lb_target_group.arn
  }

  condition {
    host_header {
      values = ["api-${local.workspace}.${var.site_domain}"]
    }
  }
}


resource "aws_acm_certificate" "cert" {
  domain_name       = var.site_domain
  subject_alternative_names = ["*.${var.site_domain}"]
  validation_method = "DNS"
}
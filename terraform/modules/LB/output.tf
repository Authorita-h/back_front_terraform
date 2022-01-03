output "frontend_target_group" {
    value = aws_lb_target_group.frontend_lb_target_group
}

output "backend_target_group" {
    value = aws_lb_target_group.backend_lb_target_group
}

output "frontend_lb_target_group" {
    value = aws_lb_target_group.frontend_lb_target_group
}

output "backend_lb_target_group" {
    value = aws_lb_target_group.backend_lb_target_group
}

output "load_balancer" {
    value = aws_lb.application_load_balancer
}

output "lb_sg" {
    value = aws_security_group.lb_security_group
}
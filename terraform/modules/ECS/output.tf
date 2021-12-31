# output "frontend_service" {
#     value = aws_ecs_service.frontend_service
# }

# output "backend_service" {
#     value = aws_ecs_service.backend_service
# }

output "cluster_sg" {
    value = aws_security_group.new_security_group
}

output "ecs_cluster_id" {
    value = aws_ecs_cluster.ecs_cluster.id
}
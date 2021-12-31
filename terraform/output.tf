output "rds_endpoint_address" {
  value = module.rds_database.rds_endpoint_address.address
}

output "load_balancer_dns_name" {
  value = module.load_balancer.load_balancer.dns_name
}

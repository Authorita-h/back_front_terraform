output "hosted_zone" {
    value = aws_route53_zone.route53_zone
}

output "certificate_arn" {
    value = module.certificate.certificate.arn
}

output "ecr_frontend" {
  value = module.repositories.ecr_frontend
}

output "ecr_backend" {
  value = module.repositories.ecr_backend
}
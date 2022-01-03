data "aws_route53_zone" "zone" {
  name = var.site_domain
}
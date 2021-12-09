resource "aws_route53_zone" "route53_zone" {
  name = var.site_domain
}

resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.route53_zone.zone_id
  name = var.site_domain
  type = "A"

  alias {
    name = var.load_balancer_name
    zone_id = var.load_balancer_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_record" {
  zone_id = aws_route53_zone.route53_zone.zone_id
  name = "www"
  type = "CNAME"
  ttl = "5"
  records = [ var.site_domain ]
}
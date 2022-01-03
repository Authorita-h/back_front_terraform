# resource "aws_route53_zone" "route53_zone" {
#   name = var.site_domain
# }

resource "aws_route53_record" "a_record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  # zone_id = aws_route53_zone.route53_zone.zone_id
  count = local.workspace == "prod" ? 1 : 0
  name    = var.site_domain
  type    = "A"

  alias {
    name                   = var.load_balancer_name
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "workspace_record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${local.workspace}.${var.site_domain}"
  type    = "A"
  count = local.workspace == "prod" ? 0 : 1

  alias {
    name                   = var.load_balancer_name
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api_record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "api.${var.site_domain}"
  type    = "A"
  count = local.workspace == "prod" ? 1 : 0

  alias {
    name                   = var.load_balancer_name
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api_workspace_record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "api-${local.workspace}.${var.site_domain}"
  type    = "A"
  count = local.workspace == "prod" ? 0 : 1

  alias {
    name                   = var.load_balancer_name
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "5"
  records = [var.site_domain]
  count = local.workspace == "prod" ? 1 : 0
}

# resource "aws_route53_record" "example" {
#   for_each = {
#     for dvo in var.cert.domain_validation_options : dvo.domain_name => {
#       name    = dvo.resource_record_name
#       record  = dvo.resource_record_value
#       type    = dvo.resource_record_type
#       zone_id = dvo.domain_name == var.site_domain ? data.aws_route53_zone.zone.zone_id : data.aws_route53_zone.zone.zone_id
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = each.value.zone_id
# }

# resource "aws_acm_certificate_validation" "example" {
#   certificate_arn         = var.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
# }

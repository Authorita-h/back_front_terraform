data "aws_route53_zone" "zone" {
  name = var.site_domain
}
# data "terraform_remote_state" "hosted_zone_id" {
#   backend = "s3"
# }
module "route53_acm_validation_records" {
  for_each = module.stage_prod.route53_aliases
  source = "../modules/aws/acm/record/v1"

  domain_validation_options = each.dvo
  zone_id = aws_route53_zone.main.zone_id
}

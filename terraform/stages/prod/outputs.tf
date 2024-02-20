output "route53_aliases" {
  value = [
    {
      name = local.domain_string
      alias = {
        name = module.cloudfront_distribution.domain
        zone_id = module.cloudfront_distribution.zone_id
        evaluate_target_health = true
      }
    },
    {
      name = "api.${local.domain_string}"
      alias = {
        name = module.public_api.target_domain_name
        zone_id = module.public_api.hosted_zone_id
        evaluate_target_health = false
      }
    }
  ]
}

output "cf_record_alias" {
  value = {
    name = module.cloudfront_distribution.domain
    zone_id = module.cloudfront_distribution.zone_id
  }
}

output "api_record_alias" {
  value = {
    name = module.public_api.target_domain_name
    zone_id = module.public_api.hosted_zone_id
  }
}

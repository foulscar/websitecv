output "nameservers" {
  value = aws_route53_zone.main.name_servers
}

output "dev-nameservers" {
  value = module.stage_dev.subdomain_ns
}

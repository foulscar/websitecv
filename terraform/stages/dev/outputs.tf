output "subdomain_ns" {
  value = aws_route53_zone.dev_main.name_servers
}

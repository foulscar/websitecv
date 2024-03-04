output "nameservers" {
  value = aws_route53_zone.main.name_servers
  description = "Use these NameServers for the Domain"
}

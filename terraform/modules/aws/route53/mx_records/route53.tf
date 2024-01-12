resource "aws_route53_record" "TXT" {
  allow_overwrite = true
  name = var.domain_name
  ttl = 172800
  type = "TXT"
  zone_id = var.zone_id

  records = var.MX_MAPPING.TXT
}

resource "aws_route53_record" "MX" {
  allow_overwrite = true
  name = var.domain_name
  ttl = 172800
  type = "MX"
  zone_id = var.zone_id

  records = var.MX_MAPPING.MX
}

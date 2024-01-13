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

resource "aws_route53_record" "DKIM" {
  for_each = toset(["", "2", "3"])
  allow_overwrite = true
  name = "protonmail${each.value}._domainkey.${var.domain_name}"
  ttl = 172800
  type = "CNAME"
  zone_id = var.zone_id

  records = [ "protonmail${each.value}.domainkey.${var.MX_MAPPING.DKIM}" ]
}

resource "aws_route53_record" "DMARC" {
  allow_overwrite = true
  name = "_dmarc.${var.domain_name}"
  ttl = 172800
  type = "TXT"
  zone_id = var.zone_id

  records = [ var.MX_MAPPING.DMARC ]
}

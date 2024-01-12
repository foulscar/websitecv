variable "domain_name" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "MX_MAPPING" {
  type = object({
    TXT = set(string)
    MX = set(string)
  })
}

variable "zone_id" {
  type = string
}

variable "ttl" {
  type = number
  default = 60
}

variable "domain_validation_options" {
  type = set(any)
}

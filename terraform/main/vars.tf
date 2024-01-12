variable "domain_name" {
  type = string
  default = "corbingrossen.me"
}

variable "gh_repo_name" {
  type = string
  default = "websitecv"
}

variable "gh_repo_owner" {
  type = string
  default = "foulscar"
}

variable "MX_MAPPING" {
  type = object({
    TXT = string
    MX = set(string)
  })
}

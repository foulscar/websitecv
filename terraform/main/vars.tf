variable "tfc_aws_dynamic_credentials" {
  description = "Object containing AWS dynamic credentials configuration"
  type = object({
    default = object({
      shared_config_file = string
    })
    aliases = map(object({
      shared_config_file = string
    }))
  })
}

variable "TFC_AWS_PROVIDER_AUTH" {
  type = string
  default = "true"
}

variable "TFC_AWS_RUN_ROLE_ARN" {
  type = string
}

variable "AWS_REGION" {
  type = string
}

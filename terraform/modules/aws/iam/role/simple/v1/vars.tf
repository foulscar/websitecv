variable "name" {
  description = "The name for the AWS IAM Role"
  type        = string
}

variable "service" {
  description = "The AWS service that assumes the role"
  type        = string
  default     = null
}

variable "policies" {
  description = "A map of policy configurations"
  type = map(object({
    name        = string
    policy_file = string
    attributes  = map(string)
  }))
}

variable "assume_role_policy" {
  description = "Use this if you would like to use a custom assume role policy"
  type = object({
    policy_file = string
    attributes = map(string)
  })
  default = null
}

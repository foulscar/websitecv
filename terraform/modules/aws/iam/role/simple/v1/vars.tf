variable "name" {
  description = "The name for the AWS IAM Role"
  type        = string
}

variable "service" {
  description = "The AWS service that assumes the role"
  type        = string
}

variable "policies" {
  description = "A map of policy configurations"
  type = map(object({
    name        = string
    policy_file = string
    attributes  = map(string)
  }))
}

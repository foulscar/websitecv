variable "name" {
  description = "The name for the AWS IAM Policy"
  type        = string
}

variable "policy_file" {
  description = "Policy JSON File to Use"
  type = string
}

variable "attributes" {
  description = "A map of attributes to change in the json file"
  type = map(string)
}

variable "role_name" {
  description = "Name of the Role to Attach the Policy to"
  type = string
}

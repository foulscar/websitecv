variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "stage_name" {
  description = "The name of the stage"
  type        = string
  default     = "dev"
}

variable "source_vpc_id" {
  description = "VPC ID that is allowed to access the API Gateway"
  type        = string
}

variable "vpc_endpoint_ids" {
  description = "VPC endpoint IDs that are allowed to access the API Gateway"
  type        = list(string)
}

variable "api_methods" {
  description = "List of API methods and their integrations"
  type = list(object({
    path       = string
    http_method = string
    type = string
    lambda_name = string
    lambda_arn = string
  }))
  default = []
}

variable "cache" {
  description = "Set API Cache"
  type = object({
    enabled = bool
    size    = string
    ttl     = number
  })
  default = {
    enabled = false
    size    = null
    ttl     = null
  }
}

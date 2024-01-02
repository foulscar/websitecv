variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "stage_name" {
  description = "The name of the stage"
  type        = string
  default     = "dev"
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

variable "cloudfront_url" {
  description = "Domain of the CloudFront Distribution to allow CORS"
  type = string
}

variable "disable_execute_api_endpoint" {
  description = "Set to True to Disable the Default API Endpoint"
  type = bool
  default = false
}

variable "domain_name" {
  description = "Domain Name to Use for the API"
  type = string
  default = null
}

variable "certificate_arn" {
  description = "ACM Certificate ARN to use if using a Domain Name"
  type = string
  default = null
}

variable "endpoint_type" {
  description = "Endpoint Type to use for the Domain Name"
  type = string
  default = "REGIONAL"
}

variable "security_policy" {
  description = "Security Policy to use for the Domain Name"
  type = string
  default = "TLS_1_2"
}

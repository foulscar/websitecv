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

variable "name" {
  description = "Name for the EventBridge Rule"
  type = string
}

variable "description" {
  description = "Description for the EventBridge Rule"
  type = string
}

variable "schedule_expression" {
  description = "Schedule Expression"
  type = string
}

variable "lambda_arn" {
  description = "Lambda ARN"
  type = string
}

variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key"
  type        = string
}

variable "hash_key_type" {
  description = "The data type for the hash key attribute"
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "The attribute to use as the range (sort) key, if any"
  type        = string
  default     = ""
}

variable "range_key_type" {
  description = "The data type for the range key attribute, if any"
  type        = string
  default     = "S"
}

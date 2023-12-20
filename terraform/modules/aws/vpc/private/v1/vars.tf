variable "name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones in the region"
  type        = list(string)
}

variable "allow_inbound_cidr" {
  description = "CIDR block to allow inbound traffic from"
  type        = string
}

variable "allow_outbound_cidr" {
  description = "CIDR block to allow outbound traffic to"
  type        = string
}

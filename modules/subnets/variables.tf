variable "vpc_id" {
  description = "ID of the VPC where subnets will be created"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "internet_gateway_id" {
  type = string
}

variable "nat_gateway_id" {
  type        = string
  description = "The ID of the NAT Gateway"
}

# variable "public_subnet_ids" {
#   description = "List of public subnet IDs for NAT Gateway placement"
#   type        = list(string)
# }

# variable "private_subnet_cidr" {
#   description = "CIDR blocks of private subnets for route table association"
#   type        = list(string)
# }

# variable "vpc_id" {
#   description = "ID of the VPC"
#   type        = string
# }
variable "public_subnet_ids" {
  description = "List of public subnet IDs for NAT Gateway"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for route table association"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "proxy_instance_ids" {
  type = list(string)
}

variable "backend_instance_ids" {
  type = list(string)
}

variable "proxy_sg_id" {
  type = string
}

variable "backend_sg_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

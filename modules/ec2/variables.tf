variable "public_subnet_ids" {
  description = "List of public subnet IDs for proxy instances"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for backend instances"
  type        = list(string)
}

variable "proxy_sg_id" {
  description = "Security group ID for proxy instances"
  type        = string
}

variable "backend_sg_id" {
  description = "Security group ID for backend instances"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "key-lab"
}

variable "backend_app_files" {
  description = "Path to backend application files"
  type        = string
}
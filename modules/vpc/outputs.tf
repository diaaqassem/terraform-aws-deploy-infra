output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "igw_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

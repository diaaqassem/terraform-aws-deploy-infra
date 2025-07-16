output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

output "nat_gateway_ips" {
  description = "Elastic IP of the NAT Gateway"
  value       = [aws_eip.nat.public_ip]
}

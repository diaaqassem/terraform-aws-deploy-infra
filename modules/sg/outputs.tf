output "proxy_sg_id" {
  description = "ID of the proxy security group"
  value       = aws_security_group.proxy.id
}

output "backend_sg_id" {
  description = "ID of the backend security group"
  value       = aws_security_group.backend.id
}

output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}
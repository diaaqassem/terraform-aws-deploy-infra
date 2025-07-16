output "public_alb_dns" {
  description = "DNS name of the public ALB"
  value       = aws_lb.public_alb.dns_name
}

output "private_alb_dns" {
  description = "DNS name of the private ALB"
  value       = aws_lb.internal_alb.dns_name
}

output "public_alb_arn" {
  description = "ARN of the public ALB"
  value       = aws_lb.public_alb.arn
}

output "private_alb_arn" {
  description = "ARN of the private ALB"
  value       = aws_lb.internal_alb.arn
}

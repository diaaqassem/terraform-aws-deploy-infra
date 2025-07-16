output "proxy_instances" {
  description = "List of proxy instance IDs"
  value       = aws_instance.proxy[*].id
}

output "backend_instances" {
  description = "List of backend instance IDs"
  value       = aws_instance.backend[*].id
}

output "proxy_public_ips" {
  description = "List of proxy public IPs"
  value       = aws_instance.proxy[*].public_ip
}

output "backend_private_ips" {
  description = "List of backend private IPs"
  value       = aws_instance.backend[*].private_ip
}

output "proxy_instance_ids" {
  value = [for instance in aws_instance.proxy : instance.id]
}

output "backend_instance_ids" {
  value = [for instance in aws_instance.backend : instance.id]
}

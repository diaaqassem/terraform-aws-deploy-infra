output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_alb_dns_name" {
  description = "DNS name of the public Application Load Balancer"
  value       = module.alb.public_alb_dns
}

output "private_alb_dns_name" {
  description = "DNS name of the internal Application Load Balancer"
  value       = module.alb.private_alb_dns
}

output "proxy_public_ips" {
  description = "Public IP addresses of proxy instances"
  value       = module.ec2.proxy_public_ips
}

output "backend_private_ips" {
  description = "Private IP addresses of backend instances"
  value       = module.ec2.backend_private_ips
  sensitive   = true
}

output "nat_gateway_ips" {
  description = "Elastic IPs associated with NAT Gateways"
  value       = module.nat_gateway.nat_gateway_ips
}
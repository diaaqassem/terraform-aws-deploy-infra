provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
  vpc_name   = var.vpc_name
}

output "igw_id" {
  value = module.vpc.igw_id
}

# Subnets Module
module "subnets" {
  source              = "./modules/subnets"
  vpc_id              = module.vpc.vpc_id
  azs                 = var.availability_zones
  nat_gateway_id      = module.nat_gateway.nat_gateway_id
  internet_gateway_id = module.vpc.igw_id
}

# NAT Gateway Module
module "nat_gateway" {
  source             = "./modules/nat"
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
}

# Security Groups Module
module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

# EC2 Instances Module
module "ec2" {
  source             = "./modules/ec2"
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  proxy_sg_id        = module.sg.proxy_sg_id
  backend_sg_id      = module.sg.backend_sg_id
  key_name           = var.key_name
  backend_app_files  = var.backend_app_files
}

# Load Balancers Module
module "alb" {
  source               = "./modules/alb"
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.subnets.public_subnet_ids
  private_subnet_ids   = module.subnets.private_subnet_ids
  proxy_sg_id          = module.sg.proxy_sg_id
  backend_sg_id        = module.sg.backend_sg_id
  proxy_instance_ids   = module.ec2.proxy_instance_ids
  backend_instance_ids = module.ec2.backend_instance_ids
}

# Generate IPs file
resource "local_file" "ips_file" {
  filename = "all-ips.txt"
  content  = <<-EOT
    %{for i, ip in module.ec2.proxy_public_ips~}
    public-ip${i + 1} ${ip}
    %{endfor~}
    %{for i, ip in module.ec2.backend_private_ips~}
    private-ip${i + 1} ${ip}
    %{endfor}
  EOT
}

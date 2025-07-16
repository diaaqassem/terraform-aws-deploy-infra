# Elastic IP for NAT
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway in the first public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_ids[0]

  tags = {
    Name = "vpc-nat"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
}

# Route Table Association with private subnets
resource "aws_route_table_association" "private_subnets" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}

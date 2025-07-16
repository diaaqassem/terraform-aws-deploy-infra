resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index + length(var.azs))
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# rt
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }
  tags = {
    Name = "private-rt"
  }
}

#resource "aws_route_table_association" "private" {
#  count          = length(var.azs)
#  subnet_id      = aws_subnet.private[count.index].id
#  route_table_id = aws_route_table.private.id
#}

# VPC Configuration
resource "aws_vpc" "endava-vpc" {
  cidr_block            = var.vpc_cidr_block
  enable_dns_support    = true
  enable_dns_hostnames  = true

 tags = {
    Name = "Endava-VPC"
  }
}

# VPC Public Subnets
resource "aws_subnet" "endava-public-subnets" {
  count             = length(var.vpc_public_subnet_cidrs)
  vpc_id            = aws_vpc.endava-vpc.id
  cidr_block        = element(var.vpc_public_subnet_cidrs, count.index)
  availability_zone = element(var.vpc_azs, count.index)

  tags = {
    Name = "Endava-VPC-Public-Subnet ${count.index + 1}"
  }
}

# VPC Private Subnets
resource "aws_subnet" "endava-private-subnets" {
  count             = length(var.vpc_private_subnet_cidrs)
  vpc_id            = aws_vpc.endava-vpc.id
  cidr_block        = element(var.vpc_private_subnet_cidrs, count.index)
  availability_zone = element(var.vpc_azs, count.index)


  tags = {
    Name = "Endava-VPC-Private-Subnet ${count.index + 1}"
  }
}

# VPC Internet Gateway
resource "aws_internet_gateway" "endava-vpc-gateway" {
  vpc_id = aws_vpc.endava-vpc.id

  tags = {
    Name = "Endava-VPC-InternetGateway"
  }
}

# VPC Route Table
resource "aws_route_table" "endava-rt" {
  vpc_id = aws_vpc.endava-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.endava-vpc-gateway.id
  }

  tags = {
    Name = "Endava-RouteTable"
  }
}

# VPC Route Table Association
resource "aws_route_table_association" "endava-rt" {
  count           = length(var.vpc_public_subnet_cidrs)
  subnet_id       = element(aws_subnet.endava-public-subnets.*.id, count.index)
  route_table_id  = aws_route_table.endava-rt.id
}


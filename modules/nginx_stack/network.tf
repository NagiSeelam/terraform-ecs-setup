resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_subnet" "public" {
  for_each = local.az_map

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.public_subnet_cidr
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = each.value.public_name
  }
}

resource "aws_subnet" "web" {
  for_each = local.az_map

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.web_subnet_cidr
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name = each.value.web_name
  }
}

resource "aws_subnet" "database" {
  for_each = local.az_map

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.database_subnet_cidr
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name = each.value.database_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  for_each = local.az_map
  domain   = "vpc"

  tags = {
    Name = each.value.index == 0 ? "nat-a" : "nat-b"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each = local.az_map

  subnet_id     = aws_subnet.public[each.key].id
  allocation_id = aws_eip.nat[each.key].id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = each.value.index == 0 ? "nat-az-a" : "nat-az-b"
  }
}

resource "aws_route_table" "web" {
  for_each = local.az_map

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }

  tags = {
    Name = each.value.index == 0 ? "rt_aza" : "rt_azb"
  }
}

resource "aws_route_table_association" "web" {
  for_each = aws_subnet.web

  subnet_id      = each.value.id
  route_table_id = aws_route_table.web[each.key].id
}

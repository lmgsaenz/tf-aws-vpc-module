// VPC
locals {
  length_public_subnets   = length(var.public_subnets)
  length_private_subnets  = length(var.private_subnets)
  length_database_subnets = length(var.database_subnets)
}
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    { Name = var.name },
    var.tags,
    var.vpc_tags
  )
}

// Public Subnets
locals {
  create_public_subnets = local.length_public_subnets > 0
}

resource "aws_subnet" "public" {
  count                   = local.create_public_subnets ? local.length_public_subnets : 0
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnets, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = merge(
    { Name = try(
      var.public_subnet_names[count.index],
      var.name
    ) },
    var.tags,
  )
}

resource "aws_route_table" "public" {
  count  = local.create_public_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "public" {
  count          = local.create_public_subnets ? local.length_public_subnets : 0
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
  depends_on     = [aws_route_table.public]
}

resource "aws_route" "public_ig" {
  count                  = local.create_public_subnets && var.create_igw ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
  depends_on             = [aws_internet_gateway.this, aws_route_table.public]

}
// Private Subnets
locals {
  create_private_subnets = local.length_private_subnets > 0
}

resource "aws_subnet" "private" {
  count      = local.create_private_subnets ? local.length_private_subnets : 0
  vpc_id     = aws_vpc.this.id
  cidr_block = element(var.private_subnets, count.index)
  tags = merge(
    { Name = try(
      var.private_subnet_names[count.index],
      var.name
    ) },
    var.tags,
  )
}

resource "aws_route_table" "private" {
  count  = local.create_private_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "private" {
  count          = local.create_private_subnets ? local.length_private_subnets : 0
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private[0].id
  depends_on     = [aws_route_table.private]
}

// Database Subnets
locals {
  create_database_subnets = local.length_database_subnets > 0
}

resource "aws_subnet" "database" {
  count      = local.create_database_subnets ? local.length_database_subnets : 0
  vpc_id     = aws_vpc.this.id
  cidr_block = element(var.database_subnets, count.index)
  tags = merge(
    { Name = try(
      var.database_subnet_names[count.index],
      var.name
    ) },
    var.tags,
  )
}

// Internet Gateway
resource "aws_internet_gateway" "this" {
  count  = local.create_public_subnets && var.create_igw ? 1 : 0
  vpc_id = aws_vpc.this.id
}

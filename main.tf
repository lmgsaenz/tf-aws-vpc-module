locals {
  length_public_subnets   = length(var.public_subnets)
  length_private_subnets  = length(var.private_subnets)
  length_database_subnets = length(var.database_subnets)
}

// VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    { Name = "${var.env}-${var.name}-vpc" },
    var.tags,
    var.vpc_tags
  )
}

// Public Subnets
locals {
  create_public_subnets = local.length_public_subnets > 0
}

resource "aws_subnet" "public" {
  count                   = local.create_public_subnets || local.length_public_subnets >= length(var.azs) ? local.length_public_subnets : 0
  vpc_id                  = aws_vpc.this.id
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  cidr_block              = element(var.public_subnets, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = merge(
    { Name = try(
      "${var.env}-${var.public_subnet_names[count.index]}-subnet",
      format("${var.env}-${var.name}-${var.public_subnet_suffix}-%s-subnet", element(var.azs, count.index))
    ) },
    var.tags,
  )
}

resource "aws_route_table" "public" {
  count  = local.create_public_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = merge(
    { Name = "${var.env}-${var.name}-${var.public_subnet_suffix}-rt" },
    var.tags
  )
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
  count             = local.create_private_subnets || local.length_private_subnets >= length(var.azs) ? local.length_private_subnets : 0
  vpc_id            = aws_vpc.this.id
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  cidr_block        = element(var.private_subnets, count.index)
  tags = merge(
    { Name = try(
      "${var.env}-${var.private_subnet_names[count.index]}-subnet",
      format("${var.env}-${var.name}-${var.private_subnet_suffix}-%s-subnet", element(var.azs, count.index))
    ) },
    var.tags,
  )
}

resource "aws_route_table" "private" {
  count  = local.create_private_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = merge(
    { Name = "${var.env}-${var.name}-${var.private_subnet_suffix}-rt" },
    var.tags
  )
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
  count             = local.create_database_subnets ? local.length_database_subnets : 0
  vpc_id            = aws_vpc.this.id
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  cidr_block        = element(var.database_subnets, count.index)
  tags = merge(
    { Name = try(
      "${var.env}-${var.database_subnet_names[count.index]}-subnet",
      format("${var.env}-${var.name}-${var.database_subnet_suffix}-%s-subnet", element(var.azs, count.index))
    ) },
    var.tags,
  )
}

resource "aws_route_table" "database" {
  count  = local.create_private_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = merge(
    { Name = "${var.name}-${var.database_subnet_suffix}-rt" },
    var.tags
  )
}

resource "aws_route_table_association" "database" {
  count          = local.create_database_subnets ? local.length_database_subnets : 0
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database[0].id
  depends_on     = [aws_route_table.database]
}

// Internet Gateway
resource "aws_internet_gateway" "this" {
  count  = local.create_public_subnets && var.create_igw ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = merge(
    { Name = "${var.env}-${var.name}-igw" },
    var.tags
  )
}

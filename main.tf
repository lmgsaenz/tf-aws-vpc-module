// VPC
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
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
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

// Private Subnets
resource "aws_subnet" "private" {
  count      = length(var.private_subnets)
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

// Database Subnets
resource "aws_subnet" "database" {
  count      = length(var.database_subnets)
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

# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}
output "vpc_arn" {
  description = "The arn of the VPC"
  value       = aws_vpc.this.arn
}

# Internet Gateway
output "igw_id" {
  description = "The ID of the igw"
  value       = aws_internet_gateway.this[0].id
}
output "igw_arn" {
  description = "The arn of the IGW"
  value       = aws_internet_gateway.this[0].arn
}

# Publiс Subnets
output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}
output "public_subnet_arns" {
  description = "List of arns of public subnets"
  value       = aws_subnet.public[*].arn
}
output "public_route_table_ids" {
  description = "List of IDs of public route table "
  value       = aws_route_table.public[*].id
}
output "public_route_table_association_ids" {
  description = "List of IDs of public route table associations"
  value       = aws_route_table_association.public[*].id
}

# Private Subnets
output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}
output "private_subnet_arns" {
  description = "List of arns of private subnets"
  value       = aws_subnet.private[*].arn
}
output "private_route_table_ids" {
  description = "List of IDs of private route table "
  value       = aws_route_table.private[*].id
}
output "private_route_table_association_ids" {
  description = "List of IDs of private route table associations"
  value       = aws_route_table_association.private[*].id
}

# Private Subnets
output "database_subnet_ids" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database[*].id
}
output "database_subnet_arns" {
  description = "List of arns of public subnets"
  value       = aws_subnet.database[*].arn
}
output "database_route_table_ids" {
  description = "List of IDs of database route table "
  value       = aws_route_table.database[*].id
}
output "database_route_table_association_ids" {
  description = "List of IDs of database route table associations"
  value       = aws_route_table_association.database[*].id
}

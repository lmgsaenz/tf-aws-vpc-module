# VPC
output "vpc_id" {
  description = "The ID of VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The arn of the VPC"
  value       = module.vpc.vpc_arn
}

# Internet Gateway
output "igw_id" {
  description = "The ID of the igw"
  value       = module.vpc.igw_id
}
output "igw_arn" {
  description = "The arn of the IGW"
  value       = module.vpc.igw_arn
}

# Publiс Subnets
output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}
output "public_subnet_arns" {
  description = "List of arns of public subnets"
  value       = module.vpc.public_subnet_arns
}
output "public_route_table_ids" {
  description = "List of IDs of public route table "
  value       = module.vpc.public_subnet_ids
}
output "public_route_table_association_ids" {
  description = "List of IDs of public route table associations"
  value       = module.vpc.public_route_table_association_ids
}

# Private Subnets
output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}
output "private_subnet_arns" {
  description = "List of arns of private subnets"
  value       = module.vpc.private_subnet_arns
}
output "private_route_table_ids" {
  description = "List of IDs of private route table "
  value       = module.vpc.private_route_table_ids
}
output "private_route_table_association_ids" {
  description = "List of IDs of private route table associations"
  value       = module.vpc.private_route_table_association_ids
}

# Private Subnets
output "database_subnet_ids" {
  description = "List of IDs of database subnets"
  value       = module.vpc.private_subnet_ids
}
output "database_subnet_arns" {
  description = "List of arns of public subnets"
  value       = module.vpc.private_subnet_arns
}
output "database_route_table_ids" {
  description = "List of IDs of database route table "
  value       = module.vpc.database_route_table_ids
}
output "database_route_table_association_ids" {
  description = "List of IDs of database route table associations"
  value       = module.vpc.database_route_table_association_ids
}

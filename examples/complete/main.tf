data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    Terraform = "True",
    Env       = "dev"
  }
}

module "vpc" {
  source               = "../.."
  name                 = "lmgs"
  env                  = local.tags.Env
  azs                  = local.azs
  cidr                 = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnets   = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  private_subnets  = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  database_subnets = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]

  public_subnet_names  = ["public-1", "public2", "public3"]
  private_subnet_names = ["private1", "private2", "private3"]
  # database_subnet_names omitted to show default name generation for all three subnets

  tags = local.tags
}

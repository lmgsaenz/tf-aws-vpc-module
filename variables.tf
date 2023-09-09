// VPC
variable "cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC."
  type        = string
  default     = "default"
}
variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  type        = bool
  default     = false
}
variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  type        = bool
  default     = false
}
variable "name" {
  description = "Name to be used on all resources as identifier"
  type        = string
  default     = ""
}
variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}
variable "azs" {
  description = "A list of AZ names"
  type        = list(string)
  default     = []
}

// Public Subnets
variable "public_subnets" {
  description = "A list of CIDR public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}
variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
  type        = bool
  default     = false
}
variable "public_subnet_names" {
  description = "List of names of the public subnets that will be used in the key name of the tags, if it is empty it will be autogenerated."
  type        = list(string)
  default     = []
}
variable "public_subnet_suffix" {
  description = "Suffix to add to the name of public subnets."
  type        = string
  default     = "public"
}

// Private Subnets
variable "private_subnets" {
  description = "A list of CIDR private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
}

variable "private_subnet_names" {
  description = "List of names of the private subnets that will be used in the key name of the tags, if it is empty it will be autogenerated."
  type        = list(string)
  default     = []
}
variable "private_subnet_suffix" {
  description = "Suffix to add to the name of public subnets."
  type        = string
  default     = "private"
}

// Database Subnets
variable "database_subnets" {
  description = "A list of CIDR database subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
}

variable "database_subnet_names" {
  description = "List of names of the database subnets that will be used in the key name of the tags, if it is empty it will be autogenerated."
  type        = list(string)
  default     = []
}
variable "database_subnet_suffix" {
  description = "Suffix to add to the name of public subnets."
  type        = string
  default     = "database"
}

// Internet Gateway
variable "create_igw" {
  description = "Variable that is responsible for checking whether the internget gateway resource is created or not."
  type        = bool
  default     = true
}

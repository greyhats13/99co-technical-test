#VPC
output "network_vpc_id" {
  value = module.vpc.vpc_id
}

output "network_vpc_arn" {
  value = module.vpc.vpc_arn
}

output "network_vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

#Subnet
output "network_public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "network_public_subnet_arn" {
  value = module.vpc.public_subnet_arn
}

output "network_app_subnet_id" {
  value = module.vpc.app_subnet_id
}

output "network_app_subnet_arn" {
  value = module.vpc.app_subnet_arn
}

output "network_cache_subnet_id" {
  value = module.vpc.cache_subnet_id
}

output "network_cache_subnet_arn" {
  value = module.vpc.cache_subnet_arn
}

output "network_db_subnet_id" {
  value = module.vpc.db_subnet_id
}

output "network_db_subnet_arn" {
  value = module.vpc.db_subnet_arn
}

#Internet Gateway
output "network_igw_subnet_id" {
  value = module.vpc.igw_id
}

output "network_igw_subnet_arn" {
  value = module.vpc.igw_arn
}

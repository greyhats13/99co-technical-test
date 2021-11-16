#VPC
output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "vpc_arn" {
    value = aws_vpc.vpc.arn
}

output "vpc_cidr_block" {
    value = aws_vpc.vpc.cidr_block
}

#Subnet
output "public_subnet_id" {
    value = aws_subnet.public_subnet.*.id
}

output "public_subnet_arn" {
    value = aws_subnet.public_subnet.*.arn
}

output "app_subnet_id" {
    value = aws_subnet.app_subnet.*.id
}

output "app_subnet_arn" {
    value = aws_subnet.app_subnet.*.arn
}

output "cache_subnet_id" {
    value = aws_subnet.cache_subnet.*.id
}

output "cache_subnet_arn" {
    value = aws_subnet.cache_subnet.*.arn
}

output "db_subnet_id" {
    value = aws_subnet.db_subnet.*.id
}

output "db_subnet_arn" {
    value = aws_subnet.db_subnet.*.arn
}

#Internet Gateway
output "igw_id" {
    value = aws_internet_gateway.igw.id
}

output "igw_arn" {
    value = aws_internet_gateway.igw.arn
}
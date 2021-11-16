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

output "data_subnet_id" {
    value = aws_subnet.data_subnet.*.id
}

output "data_subnet_arn" {
    value = aws_subnet.data_subnet.*.arn
}

#Internet Gateway
output "igw_id" {
    value = aws_internet_gateway.igw.id
}

output "igw_arn" {
    value = aws_internet_gateway.igw.arn
}

#EKS
output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

#Aurora
output "aurora_id" {
  value = aws_rds_cluster.aurora_cluster.id
}

output "aurora_arn" {
  value = aws_rds_cluster.aurora_cluster.arn
}

output "aurora_cluster_endpoint" {
  value = aws_rds_cluster.aurora_cluster.endpoint
}

output "aurora_reader_endpoint" {
  value = aws_rds_cluster.aurora_cluster.reader_endpoint
}

output "aurora_master_username" {
  value = aws_rds_cluster.aurora_cluster.master_username
}

output "aurora_port" {
  value = aws_rds_cluster.aurora_cluster.port
}
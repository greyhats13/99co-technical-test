#Naming Standard
variable "region" {
  type        = string
  description = "AWS region"
}

variable "unit" {
  type        = string
  description = "business unit code"
}

variable "env" {
  type        = string
  description = "stage environment where the infrastructure will be deployed"
}

variable "code" {
  type        = string
  description = "service domain code to use"
}

variable "feature" {
  type        = string
  description = "the name of AWS services feature"
}

variable "sub" {
  type        = list(string)
  description = "the name of AWS services subfeature"
}

#VPC Arguments
variable "vpc_cidr" {
  type        = string
  description = "Network VPC CIDR"
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS SUpport"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS Hostnames"
}

#Subnets Arguments
variable "public_subnet_cidr" {
  type        = list(string)
  description = "public subnet"
}

variable "app_subnet_cidr" {
  type        = list(string)
  description = "application subnet"
}

variable "cache_subnet_cidr" {
  type        = list(string)
  description = "Cache subnet"
}

variable "db_subnet_cidr" {
  type        = list(string)
  description = "Database subnet"
}

#Elastic IP Arguments
variable "total_eip" {
  type = number
  description = "Total elastic IP"
}
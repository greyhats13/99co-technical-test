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
  type        = list(string)
  description = "the name of AWS services feature"
}

#Network Load Balancer Arguments
variable "enable_cross_zone_load_balancing" {
  type        = bool
  description = "Enable Crozz Zone Load Balancing"
}

variable "total_eip" {
  type        = number
  description = "Total Network Load Balancer Elastic IP"
}

#Amazon Certificate Manager
variable "domain_name" {
  type        = string
  description = "ACM Domain name"
}

variable "validation_method" {
  type        = string
  description = "ACM Validation method"
}

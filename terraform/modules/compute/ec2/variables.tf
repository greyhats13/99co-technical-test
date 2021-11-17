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

#EC2
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}
variable "ami" {
  type        = string
  description = "EC2 AMI"
}

variable "associate_public_ip_address" {
  type = bool
  description = "EC2 associate public ip address"
}

variable "volume_type" {
  type        = string
  description = "EC2 volume type"
}

variable "volume_size" {
  type        = number
  description = "EC2 volume type"
}

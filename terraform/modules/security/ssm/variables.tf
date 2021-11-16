#Standarization
variable "unit" {
  type = string
  description = "Service business unit"
}

variable "env" {
  type = string
  description = "Service stage environment"
}

variable "code" {
  type = string
  description = "Service domain code"
}

variable "feature" {
  type = string
  description = "Service domain feature"
}

variable "sub" {
  type = string
  description = "Service domain subfeature"
}

variable "region" {
  type = string
  description = "AWS region"
}


variable "overwrite" {
  default = true
}

variable "list_of_ssm" {
  type = map(string)
  description = "list of ssm parameters"
}
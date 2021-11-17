#Naming Standard
variable "unit" {
  type        = string
  description = "business unit code"
  default     = "rll"
}

variable "env" {
  type        = string
  description = "stage environment where the service or cloud resource will be deployed"
  default     = "prd"
}

variable "code" {
  type        = string
  description = "service domain code to use"
  default     = "compute"
}

variable "feature" {
  type        = string
  description = "the name of AWS services feature"
  default     = "eks"
}

variable "sub" {
  type        = list(string)
  description = "the name of AWS services subfeature"
  default     = ["cluster", "node"]
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-southeast-1"
}


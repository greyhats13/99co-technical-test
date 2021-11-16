#Standarization
variable "unit" {
  type        = string
  description = "Service business unit"
}

variable "env" {
  type        = string
  description = "Service stage environment"
}

variable "code" {
  type        = string
  description = "Service domain code"
}

variable "feature" {
  type        = string
  description = "Service domain feature"
}

variable "sub" {
  type        = string
  description = "Service domain subfeature"
}

variable "region" {
  type        = string
  description = "AWS region"
}

#Google Workspace
variable "user" {
  description = "User identity"
}

#SSM
variable "overwrite" {
  type        = bool
  description = "(optional) Overwrite an existing parameter. If not specified, will default to false if the resource has not been created by terraform to avoid overwrite of existing resource and will default to true otherwise (terraform lifecycle rules should then be used to manage the update behavior)."
  default     = true
}

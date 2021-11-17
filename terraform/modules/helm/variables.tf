#Naming Standard
variable "unit" {
  type        = string
  description = "business unit code"
}

variable "env" {
  type        = string
  description = "stage environment where the service or cloud resource will be deployed"
  default     = null
}

variable "code" {
  type        = string
  description = "service domain code to use"
}

variable "feature" {
  type        = string
  description = "service domain feature to use"
}

variable "region" {
  type        = string
  description = "DO region"
}

variable "repository" {
  type        = string
  description = "Helm chart repository"
}

variable "chart" {
  type        = string
  description = "helm chart"
}

variable "values" {
  type        = list(string)
  description = "helm values file"
}

variable "helm_sets" {
  type        = list(object({ name : string, value : any }))
  description = "list of helm set"
}

variable "override_namespace" {
  type        = string
  description = "Override default namespace"
  default     = null
}

variable "no_env" {
  type        = bool
  description = "Remove env on naming standard"
  default     = false
}

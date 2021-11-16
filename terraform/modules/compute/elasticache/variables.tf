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

variable "engine" {
  type        = string
  description = "Elasticache engine"
}

variable "engine_version" {
  type        = string
  description = "Elasticache engine version"
}

variable "maintenance_window" {
  type        = string
  description = "Elasticache maitenance window"
}

variable "multi_az_enabled" {
  type        = bool
  description = "Elasticache Multi AZ enabled"
}

variable "node_type" {
  type        = string
  description = "Elasticache Node Type"
}

variable "parameter_group_name" {
  type        = string
  description = "Elasticache parameter group name"
}

variable "automatic_failover_enabled" {
  type        = bool
  description = "Elasticache to enable failover"
}

variable "port" {
  type        = number
  description = "Elasticache port number"
}

variable "snapshot_window" {
  type        = string
  description = "Elasticache Snapshot Window"
}

variable "transit_encryption_enabled" {
  type        = bool
  description = "Elastiache Transit Encryption Enabled"
}

variable "at_rest_encryption_enabled" {
  type        = bool
  description = "Enable at rest encryption using KMS"
}

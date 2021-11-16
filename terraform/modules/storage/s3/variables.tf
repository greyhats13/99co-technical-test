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

variable "acl" {
  type        = string
  description = "(Optional) The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write. Defaults to private. Conflicts with grant"
}

variable "force_destroy" {
  type        = bool
  description = "(Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable"
}

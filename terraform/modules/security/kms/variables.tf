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

#KMS
variable "key_usage" {
  type        = string
  description = "(Optional) Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY. Defaults to ENCRYPT_DECRYPT."
}

variable "deletion_window_in_days" {
  type        = number
  description = "(Optional) Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days."
}

variable "is_enabled" {
  type        = bool
  description = "(Optional) Specifies whether the key is enabled. Defaults to true."
  default     = true
}

variable "enable_key_rotation" {
  type        = bool
  description = "(Optional) Specifies whether key rotation is enabled. Defaults to false."
}

variable "customer_master_key_spec" {
  type        = string
  description = "(Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1. Defaults to SYMMETRIC_DEFAULT."
  default     = "SYMMETRIC_DEFAULT"
}

variable "policy" {
  type        = string
  description = "(Optional) A valid policy JSON document. Although this is a key policy, not an IAM policy, an aws_iam_policy_document, in the form that designates a principal, can be used. "
}

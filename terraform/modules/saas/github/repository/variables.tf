
#Github repository
variable "unit" {
  type        = string
  description = "service business unit"
}

variable "code" {
  type        = string
  description = "service domain code"
}

variable "description" {
  type        = string
  description = "(Optional) A description of the repository."
  default     = null
}

variable "visibility" {
  type        = string
  description = "(Optional) Can be public or private. If your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+, visibility can also be internal. The visibility parameter overrides the private parameter."
  default     = null
}

variable "auto_init" {
  type        = bool
  description = "(Optional) Set to true to produce an initial commit in the repository."
  default     = null
}

variable "has_issues" {
  type        = bool
  description = "(Optional) Set to true to enable the GitHub Issues features on the repository."
  default     = null
}

variable "has_projects" {
  type        = bool
  description = "(Optional) Set to true to enable the GitHub Projects features on the repository. Per the GitHub documentation when in an organization that has disabled repository projects it will default to false and will otherwise default to true. If you specify true when it has been disabled it will return an error."
  default     = null
}

variable "has_wiki" {
  type        = bool
  description = "(Optional) Set to true to enable the GitHub Wiki features on the repository."
  default     = null
}

#Github branch
variable "source_branch" {
  type        = string
  description = "(Optional) The branch name to start from. Defaults to main."
  default     = "main"
}

variable "branch_name" {
  type        = string
  description = "(Required) The repository branch to create."
  default     = "dev"
}

#Github environment secret
variable "env" {
  type        = string
  description = "Service stage environment"
}

variable "secret_name" {
  type        = list(string)
  description = "(Required) Name of the secret."
}

variable "plaintext_value" {
  type        = list(string)
  description = "(Optional) Plaintext value of the secret to be encrypted."
}

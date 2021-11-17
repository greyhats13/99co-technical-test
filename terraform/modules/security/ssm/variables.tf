variable "region" {
  default = "ap-southeast-1"
}

variable "unit" {
  default = "99c"
}

variable "env" {
  default = "dev"
}

variable "code" {
  default = "ssm"
}

variable "feature" {
  default = "cloudflare"
}

variable "creator" {
  default = "tf"
}

variable "overwrite" {
  type = bool
  description = "overwrite SSM value changes"
}

variable "list_of_ssm" {
  type = map(string)
  description = "list of ssm parameters"
}
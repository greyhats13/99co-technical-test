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

#Parameter Group
variable "parameter_group_family" {
  type        = string
  description = "Aurora parameter group family"
}

#Aurora Cluster
variable "engine_mode" {
  type        = string
  description = "Aurora engine mode"
}

variable "engine" {
  type        = string
  description = "Aurora engine"
}

variable "engine_version" {
  type        = string
  description = "Aurora engine version"
}
variable "master_username" {
  type        = string
  description = "Aurora Master username"
}

variable "port" {
  type        = number
  description = "Aurora port"
}

variable "backup_retention_period" {
  type        = string
  description = "Aurora backup retention period"
}

variable "preferred_backup_window" {
  type        = string
  description = "Aurora preferred backup window"
}

variable "iam_database_authentication_enabled" {
  type        = bool
  description = "Aurora IAM authentication"
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Aurora copy tags to snapshot"
}

variable "storage_encrypted" {
  type        = bool
  description = "Aurora storage encrypted using KMS CMK"
}

variable "backtrack_window" {
  type        = number
  description = "Aurora Backtrack window"
}

variable "allow_major_version_upgrade" {
  type        = bool
  description = "Aurora allow major version upgrade"
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "Aurora enable cloudwatch logs exports"
}

variable "deletion_protection" {
  type        = bool
  description = "Auora deletion protection"
}

variable "apply_immediately" {
  type        = bool
  description = "Aurora apply immediately"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Aurora Skip Final Snapshot"
}

variable "number_of_instance" {
  type        = number
  description = "Aurora number of instance"
}

variable "instance_class" {
  type        = string
  description = "Aurora instance class"
}

variable "publicly_accessible" {
  type        = bool
  description = "Aurora publicly accessible"
}

variable "performance_insights_enabled" {
  type        = bool
  description = "Aurora performance insights enabled"
}

variable "monitoring_interval" {
  type        = number
  description = "Aurora Monitoring interval"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Aurora auto minor version upgrade"
}

variable "ca_cert_identifier" {
  type        = string
  description = "Aurora CA Certificate Identifier"
}

variable "service_namespace" {
  type        = string
  description = "Aurora autoscaling service namespace"
}

variable "scalable_dimension" {
  type        = string
  description = "Aurora Autoscaling target scalable dimension"
}

variable "min_capacity" {
  type        = number
  description = "Aurora Autoscaling target minimum capacity"
}

variable "max_capacity" {
  type        = number
  description = "Aurora Autoscaling target maximum capacity"
}

variable "policy_type" {
  type        = string
  description = "Aurora Autoscaling policy type"
}

variable "predefined_metric_type" {
  type        = string
  description = "Aurora Autoscaling predefined metric type"
}

variable "target_value" {
  type        = number
  description = "Aurora Autoscaling Target Value"
}

variable "scale_in_cooldown" {
  type        = number
  description = "Aurora Autoscaling policy scale in cooldown"
}

##Scale outcooldown
variable "scale_out_cooldown" {
  type        = number
  description = "Aurora Autoscaling policy scale out cooldown"
}


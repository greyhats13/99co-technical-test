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
  description = "service domain feature to use"
}

#ECS Service
variable "requires_compatibilities" {
  type        = list(string)
  description = "Fargate compatibilities"
}

variable "cpu" {
  type        = number
  description = "Task CPU"
}

variable "memory" {
  type        = number
  description = "Task Memory"
}

variable "memory_reservation" {
  type        = number
  description = "Task Memory Reservation"
}

variable "container_port" {
  type        = number
  description = "Container port"
}

variable "protocol" {
  type        = string
  description = "NLB listener Protocol"
}

variable "target_type" {
  type        = string
  description = "NLB target_type"
}

variable "deregistration_delay" {
  type        = number
  description = "NLB describe your variable"
}

variable "health_check_interval" {
  type        = number
  description = "NLB healtcheck interval"
}

variable "healthy_threshold" {
  type        = number
  description = "NLB healthy threshold"
}

variable "unhealthy_threshold" {
  type        = number
  description = "NLB unhealthy threshold"
}


variable "iam_policy" {
  type        = string
  description = "IAM policy for task"
}

variable "network_mode" {
  type        = string
  description = "Task network mode"
}

variable "launch_type" {
  type        = string
  description = "ECS launch type"
}

#ECS Autoscaling
variable "predefined_metric_type" {
  type        = list(string)
  description = "predefined_metric_type"
}

variable "scale_in_cooldown" {
  type        = number
  description = "Scale in cooldown"
}

variable "scale_out_cooldown" {
  type        = number
  description = "Scale out cooldown"
}

variable "target_value" {
  type        = list(number)
  description = "Autoscaling target value"
}

variable "policy_type" {
  type        = string
  description = "Autoscaling policy type"
}

variable "min_capacity" {
  type        = number
  description = "autoscaling minimum capacity"
}

variable "max_capacity" {
  type        = number
  description = "autoscaling maximum capacity"
}


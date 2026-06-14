variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "service" {
  type = string
}

variable "project" {
  type = string
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "web_subnet_cidrs" {
  type = list(string)
}

variable "database_subnet_cidrs" {
  type = list(string)
}

variable "acm_certificate_arn" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type    = number
  default = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "ecs_cpu" {
  type = number
}

variable "ecs_memory" {
  type = number
}

variable "desired_count" {
  type = number
}

variable "enable_execute_command" {
  type    = bool
  default = true
}

variable "autoscaling_min_capacity" {
  type = number
}

variable "autoscaling_max_capacity" {
  type = number
}

variable "autoscaling_cpu_target" {
  type    = number
  default = 60
}

variable "log_retention_in_days" {
  type    = number
  default = 30
}

variable "alb_deletion_protection" {
  type    = bool
  default = true
}

variable "alb_access_log_bucket_name" {
  type    = string
  default = null
}

variable "db_name" {
  type = string
}

variable "db_master_username" {
  type = string
}

variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_engine_version" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_allocated_storage_gb" {
  type = number
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "multi_az_db" {
  type    = bool
  default = true
}

variable "backup_retention_period" {
  type    = number
  default = 1
}

variable "db_deletion_protection" {
  type    = bool
  default = true
}

variable "db_apply_immediately" {
  type    = bool
  default = false
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "create_dns_record" {
  type    = bool
  default = false
}

variable "route53_zone_name" {
  type    = string
  default = null
}

variable "dns_name" {
  type    = string
  default = null
}

variable "vpc_cidr" { type = string }
variable "availability_zones" { type = list(string) }
variable "public_subnet_cidrs" { type = list(string) }
variable "web_subnet_cidrs" { type = list(string) }
variable "database_subnet_cidrs" { type = list(string) }
variable "acm_certificate_arn" { type = string }
variable "container_image" { type = string }
variable "container_port" { type = number }
variable "health_check_path" { type = string }
variable "ecs_cpu" { type = number }
variable "ecs_memory" { type = number }
variable "desired_count" { type = number }
variable "enable_execute_command" { type = bool }
variable "autoscaling_min_capacity" { type = number }
variable "autoscaling_max_capacity" { type = number }
variable "autoscaling_cpu_target" { type = number }
variable "log_retention_in_days" { type = number }
variable "alb_deletion_protection" { type = bool }
variable "alb_access_log_bucket_name" { 
 type = string
 default = null
}
variable "db_name" { type = string }
variable "db_master_username" { type = string }
variable "db_engine" { type = string }
variable "db_engine_version" { type = string }
variable "db_instance_class" { type = string }
variable "db_allocated_storage_gb" { type = number }
variable "db_port" { type = number }
variable "multi_az_db" { type = bool }
variable "backup_retention_period" { type = number }
variable "db_deletion_protection" { type = bool }
variable "db_apply_immediately" { type = bool }
variable "kms_key_id" { 
  type = string 
  default = null
}
variable "create_dns_record" { type = bool }
variable "route53_zone_name" { type = string }
variable "dns_name" { type = string }
variable "zone_id" { type = string }

module "nginx_stack" {
  source = "../../modules/nginx_stack"

  aws_region                 = var.aws_region
  environment                = var.environment
  service                    = var.service
  project                    = var.project
  additional_tags            = var.additional_tags
  vpc_cidr                   = var.vpc_cidr
  availability_zones         = var.availability_zones
  public_subnet_cidrs        = var.public_subnet_cidrs
  web_subnet_cidrs           = var.web_subnet_cidrs
  database_subnet_cidrs      = var.database_subnet_cidrs
  acm_certificate_arn        = var.acm_certificate_arn
  container_image            = var.container_image
  container_port             = var.container_port
  health_check_path          = var.health_check_path
  ecs_cpu                    = var.ecs_cpu
  ecs_memory                 = var.ecs_memory
  desired_count              = var.desired_count
  enable_execute_command     = var.enable_execute_command
  autoscaling_min_capacity   = var.autoscaling_min_capacity
  autoscaling_max_capacity   = var.autoscaling_max_capacity
  autoscaling_cpu_target     = var.autoscaling_cpu_target
  log_retention_in_days      = var.log_retention_in_days
  alb_deletion_protection    = var.alb_deletion_protection
  alb_access_log_bucket_name = var.alb_access_log_bucket_name
  db_name                    = var.db_name
  db_master_username         = var.db_master_username
  db_engine                  = var.db_engine
  db_engine_version          = var.db_engine_version
  db_instance_class          = var.db_instance_class
  db_allocated_storage_gb    = var.db_allocated_storage_gb
  db_port                    = var.db_port
  multi_az_db                = var.multi_az_db
  backup_retention_period    = var.backup_retention_period
  db_deletion_protection     = var.db_deletion_protection
  db_apply_immediately       = var.db_apply_immediately
  kms_key_id                 = var.kms_key_id  
  create_dns_record			 = var.create_dns_record
  route53_zone_name 	     = var.route53_zone_name
  dns_name         			 = var.dns_name
  zone_id                    = var.zone_id

}

output "service_url" {
  value = module.nginx_stack.service_url
}

output "rds_endpoint" {
  value = module.nginx_stack.rds_endpoint
}

output "alb_dns_name" {
  value = module.nginx_stack.alb_dns_name
}

output "app_fqdn" {
  value = module.nginx_stack.app_fqdn
  
}




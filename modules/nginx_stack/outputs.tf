output "service_url" {
  value = "https://${aws_lb.nginx_alb.dns_name}"
}

output "rds_endpoint" {
  value = aws_db_instance.rds.address
}

output "rds_master_user_secret_arn" {
  value = aws_db_instance.rds.master_user_secret[0].secret_arn
}

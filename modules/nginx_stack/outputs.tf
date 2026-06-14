output "service_url" {
  value = "https://${aws_lb.nginx_alb.dns_name}"
}

output "rds_endpoint" {
  value = aws_db_instance.rds.address
}



output "alb_dns_name" {
  value = aws_lb.nginx_alb.dns_name
}

output "app_fqdn" {
  value = local.fqdn
}
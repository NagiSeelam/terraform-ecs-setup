

resource "aws_route53_record" "alb_alias" {
  count   = var.create_dns_record ? 1 : 0
  zone_id = var.zone_id
  name    = local.fqdn
  type    = "A"

  alias {
    name                   = aws_lb.nginx_alb.dns_name
    zone_id                = aws_lb.nginx_alb.zone_id
    evaluate_target_health = true
  }
}
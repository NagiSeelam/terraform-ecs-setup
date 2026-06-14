locals {
  name_prefix = "${var.environment}-${var.service}"

  az_map = {
  for i, az in var.availability_zones : az => {
    index                = i
    public_subnet_cidr   = var.public_subnet_cidrs[i]
    web_subnet_cidr      = var.web_subnet_cidrs[i]
    database_subnet_cidr = var.database_subnet_cidrs[i]

    public_name   = "public-${i + 1}"
    web_name      = "web-${i + 1}"
    database_name = "database-${i + 1}"
  }
}

 fqdn = var.route53_zone_name == null ? null : (
    var.dns_name == null || var.dns_name == ""
    ? var.route53_zone_name
    : "${var.dns_name}.${var.route53_zone_name}"
  )



  alb_log_bucket_name = var.alb_access_log_bucket_name != null ? var.alb_access_log_bucket_name : lower(substr(replace("${var.project}-${var.environment}-${var.service}-alb-logs", "_", "-"), 0, 63))
}

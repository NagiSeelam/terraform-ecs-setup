resource "aws_s3_bucket" "alb_logs" {
  count  = var.alb_access_log_bucket_name == null ? 1 : 0
  bucket = local.alb_log_bucket_name
}

resource "aws_s3_bucket_public_access_block" "alb_logs" {
  count                   = var.alb_access_log_bucket_name == null ? 1 : 0
  bucket                  = aws_s3_bucket.alb_logs[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_logs" {
  count  = var.alb_access_log_bucket_name == null ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "alb_logs" {
  count  = var.alb_access_log_bucket_name == null ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSLogDeliveryWrite"
        Effect = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.alb_logs[0].arn}/AWSLogs/*"
      },
      {
        Sid    = "AWSLogDeliveryAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.alb_logs[0].arn
      }
    ]
  })
}

resource "aws_lb" "nginx_alb" {
  name                       = "nginx-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [for az in var.availability_zones : aws_subnet.public[az].id]
  security_groups            = [aws_security_group.ecs_sgrp.id]
  enable_deletion_protection = var.alb_deletion_protection
  enable_http2               = true

  access_logs {
    bucket  = var.alb_access_log_bucket_name == null ? aws_s3_bucket.alb_logs[0].bucket : var.alb_access_log_bucket_name
    enabled = true
  }

  depends_on = [aws_s3_bucket_policy.alb_logs]

  tags = {
    Name = "${var.environment}-alb"
  }
}

resource "aws_lb_target_group" "nginx_target_group" {
  name        = "nginx-target-group"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    path = var.health_check_path
  }
}

resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}

/** resource "aws_lb_listener" "nginx_https_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  } 
}*/

resource "aws_security_group" "ecs_sgrp" {
  name        = "sgrp-web-server"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "sgrp-web-server"
  }
}

resource "aws_security_group" "database_sgrp" {
  name        = "sgrp-database"
  description = "Allow inbound traffic from application security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "sgrp-database"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_in" {
  security_group_id = aws_security_group.ecs_sgrp.id
  description       = "Allow HTTP from internet"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_in" {
  security_group_id = aws_security_group.ecs_sgrp.id
  description       = "Allow HTTPS from internet"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs_sgrp.id
  description                  = "Allow traffic from ALB to service"
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecs_sgrp.id
}

resource "aws_vpc_security_group_egress_rule" "ecs_all_out" {
  security_group_id = aws_security_group.ecs_sgrp.id
  description       = "outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "database_from_app" {
  security_group_id            = aws_security_group.database_sgrp.id
  description                  = "Allow traffic from application layer"
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecs_sgrp.id
}

resource "aws_vpc_security_group_egress_rule" "database_all_out" {
  security_group_id = aws_security_group.database_sgrp.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

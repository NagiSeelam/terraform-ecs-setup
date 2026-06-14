resource "aws_db_subnet_group" "subnet_group" {
  name       = "main"
  subnet_ids = [for az in var.availability_zones : aws_subnet.database[az].id]
}

resource "aws_db_instance" "rds" {
  allocated_storage           = var.db_allocated_storage_gb
  db_subnet_group_name        = aws_db_subnet_group.subnet_group.id
  engine                      = var.db_engine
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  multi_az                    = var.multi_az_db
  db_name                     = var.db_name
  username                    = var.db_master_username
  manage_master_user_password = true
  port                        = var.db_port
  storage_encrypted           = true
  kms_key_id                  = var.kms_key_id
  skip_final_snapshot         = false
  final_snapshot_identifier   = "${var.environment}-${var.service}-final-snapshot"
  backup_retention_period     = var.backup_retention_period
  deletion_protection         = false
  publicly_accessible         = false
  vpc_security_group_ids      = [aws_security_group.database_sgrp.id]
  apply_immediately           = var.db_apply_immediately
}

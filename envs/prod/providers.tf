provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge({
      Environment = var.environment
      Service     = var.service
      ManagedBy   = "terraform"
      Project     = var.project
    }, var.additional_tags)
  }
}

variable "aws_region" { type = string }
variable "environment" { type = string }
variable "service" { type = string }
variable "project" { type = string }
variable "additional_tags" { type = map(string) }

# Production-ready AWS Terraform (preserving original naming)

This package keeps the key naming from the original exercise where practical, including:

- ALB name: `nginx-alb`
- Target group name: `nginx-target-group`
- ECS cluster name pattern: `${environment}-cluster`
- ECS task family: `nginx-task`
- ECS service name pattern: `${environment}-${service}`
- Container name: `nginx-container`
- IAM role names: `ecs-task-role`, `ecs-execution-role`
- Security group names: `sgrp-web-server`, `sgrp-database`
- Subnet Name tags: `public-1`, `public-2`, `web-1`, `web-2`, `database-1`, `database-2`

## Structure

```text
.
├── modules/
│   └── nginx_stack/
│       ├── ecs.tf
│       ├── iam.tf
│       ├── lb.tf
│       ├── locals.tf
│       ├── network.tf
│       ├── outputs.tf
│       ├── rds.tf
│       ├── security.tf
│       └── variables.tf
├── envs/
│   ├── dev/
│   ├── test/
│   └── prod/
└── .gitignore
```

## How to use

### Test
```bash
cd envs/test
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

### Production
```bash
cd envs/prod
terraform init
terraform plan
terraform apply
```

## Notes

- Update `acm_certificate_arn` before applying.
- Each environment root reuses the same shared module.
- This is production-ready by default: HTTPS, strict security groups, Multi-AZ, encrypted RDS, managed DB secret, backups, final snapshot, logging, and autoscaling.

# Production-ready AWS Terraform 

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

├── modules/
│   └── nginx_stack/
│       ├── ecs.tf
│       ├── iam.tf
        ├── dns.tf
│       ├── lb.tf
│       ├── locals.tf
│       ├── network.tf
│       ├── outputs.tf
│       ├── rds.tf
│       ├── security.tf
│       └── variables.tf
├── envs/
│   ├── nonprod/│   
│   └── prod/
└── .gitignore


## How to use

### Production
``bash
cd envs/prod
terraform init
terraform plan
terraform apply

#### Nonprod folder is empty but can be replicated similar to prod


## Corrections made

 - Invalid CIDR block
 - Duplicate / overlapping subnet CIDRs
 - Web subnet CIDR too large
 - Wrong execution role reference
 - ECS service port mismatch
 - Target group attachment is wrong
 - EIP incorrect attribute
 - RDS engine version incorrect
 - RDS DB subnet group using public subnets
 - Missing required security group rule
 - Missing variables


## Improvements made

- Replace the shared/no-ingress SG design with separate ALB/ECS/DB SGs 
- Change DB SG from 0.0.0.0/0:3306 to ECS SG -> 5432 
- Remove hard-coded DB credentials; use Secrets Manager integration 
- Add HTTPS + HTTP-to-HTTPS redirect on ALB  
- Enable ALB and RDS deletion protection ,
- Use both private subnets for the ECS service 
- Add per-AZ NAT gateways and route tables for HA 
- Add provider version pinning, typed variables, and default tags 

## Notes

- Update `acm_certificate_arn` in using https alb listener.
- Each environment root reuses the same shared module. Nonprod folder is empty, can be replicated similar to pord
- strict security groups, Multi-AZ, encrypted RDS, managed DB secret, backups, final snapshot, logging, and autoscaling.

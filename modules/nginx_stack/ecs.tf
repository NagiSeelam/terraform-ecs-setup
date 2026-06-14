resource "aws_cloudwatch_log_group" "nginx_log_group" {
  name              = "/ecs/${var.environment}-${var.service}"
  retention_in_days = var.log_retention_in_days
}

resource "aws_ecs_cluster" "nginx_cluster" {
  name = "${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = tostring(var.ecs_cpu)
  memory                   = tostring(var.ecs_memory)
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "nginx-container"
      image = var.container_image
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.nginx_log_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "nginx"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "nginx_service" {
  name                   = "${var.environment}-${var.service}"
  cluster                = aws_ecs_cluster.nginx_cluster.id
  task_definition        = aws_ecs_task_definition.nginx_task.arn
  launch_type            = "FARGATE"
  desired_count          = var.desired_count
  enable_execute_command = var.enable_execute_command

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets         = [for az in var.availability_zones : aws_subnet.web[az].id]
    security_groups = [aws_security_group.ecs_sgrp.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
    container_name   = "nginx-container"
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.nginx_listener]
}

resource "aws_appautoscaling_target" "nginx_service" {
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${aws_ecs_cluster.nginx_cluster.name}/${aws_ecs_service.nginx_service.name}"
  min_capacity       = var.autoscaling_min_capacity
  max_capacity       = var.autoscaling_max_capacity
}

resource "aws_appautoscaling_policy" "nginx_service_cpu" {
  name               = "${var.environment}-${var.service}-cpu"
  policy_type        = "TargetTrackingScaling"
  service_namespace  = aws_appautoscaling_target.nginx_service.service_namespace
  scalable_dimension = aws_appautoscaling_target.nginx_service.scalable_dimension
  resource_id        = aws_appautoscaling_target.nginx_service.resource_id

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.autoscaling_cpu_target
  }
}

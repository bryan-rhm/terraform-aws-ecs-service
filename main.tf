resource "aws_ecs_service" "this" {
  name                               = var.name
  cluster                            = var.cluster_arn
  task_definition                    = var.task_definition_arn
  desired_count                      = var.desired_count
  propagate_tags                     = var.propagate_tags
  launch_type                        = var.launch_type
  health_check_grace_period_seconds  = var.load_balancer == null ? null : var.health_check_grace_period
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_percent

  dynamic "service_registries" {
    for_each = var.service_registry == null ? [] : [1]

    content {
      registry_arn   = var.service_registry.arn
      port           = try(var.service_registry.port, null)
      container_port = try(var.service_registry.container_port, null)
      container_name = try(var.service_registry.container_name, null)
    }
  }

  dynamic "network_configuration" {
    for_each = var.network_config == null ? [] : [1]

    content {
      subnets          = var.network_config.subnets
      security_groups  = var.network_config.security_groups
      assign_public_ip = try(var.network_config.public_ip, null)
    }
  }

  dynamic "load_balancer" {
    for_each = var.load_balancer == null ? [] : [1]

    content {
      target_group_arn = var.load_balancer.target_group_arn
      container_name   = var.load_balancer.container_name
      container_port   = var.load_balancer.container_port
    }
  }
  
  dynamic "capacity_provider_strategy" {
    for_each = { for capacity in var.capacity_provider_strategy: capacity.name => capacity }
    
    content {
      base              = each.value.base
      weight            = each.value.weight
      capacity_provider = each.key
    }
  }

  tags = var.tags
}

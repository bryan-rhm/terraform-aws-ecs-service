provider "aws" {
  region = "us-east-1"
}

module "ecs-service" {
  source                     = "../"
  name                       = "service"
  cluster_arn                = "arn:aws:ecs:"
  task_definition_arn        = "arn:aws:ecs:"
  desired_count              = 2
  propagate_tags             = "TASK_DEFINITION"
  launch_type                = "FARGATE"
  health_check_grace_period  = 15
  deployment_maximum_percent = 200
  deployment_minimum_percent = 100

  network_config = {
    subnets          = ["subnet-12345"]
    security_groups  = ["sg-12345"]
    assign_public_ip = false
  }
  load_balancer = {
    target_group_arn = "arn:aws:elasticloadbalancing:12345"
    container_name   = "nginx"
    container_port   = 80
  }
}

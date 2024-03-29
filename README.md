# Terraform AWS ECS Service Module

This terraform module provisions an ECS service.

## Usage

Example on how to provision an AWS ECS Service with [FARGATE SPOT](https://aws.amazon.com/es/blogs/aws/aws-fargate-spot-now-generally-available/) containers.

```hcl
module "ecs_service" {
  source                     = "bryan-rhm/ecs-service/aws"
  version                    = "..." # select your prefered version
  name                       = "service-name"
  cluster_arn                = module.ecs_cluster.output.arn
  task_definition_arn        = module.ecs_task_definition.output.arn
  desired_count              = 2
  propagate_tags             = "TASK_DEFINITION"
  launch_type                = "FARGATE"
  deployment_maximum_percent = 200
  deployment_minimum_percent = 100

  network_config = {
    subnets         = module.vpc.output.private_subnet_ids
    security_groups = ["sg-id-1234"]
  }

  capacity_provider_strategy = [{
    base   = 2
    name   = "FARGATE_SPOT"
    weight = 1
  }]

  load_balancer = {
    target_group_arn = module.alb_target_group.output.arn
    container_name   = "container-name"
    container_port   = 8080
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.43.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.70.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity_provider_strategy"></a> [capacity\_provider\_strategy](#input\_capacity\_provider\_strategy) | (Optional) Capacity provider strategies to use for the service. Can be one or more. These can be updated without destroying and recreating the service only if force\_new\_deployment = true and not changing from 0 capacity\_provider\_strategy blocks to greater than 0, or vice versa. | <pre>list(object({<br>    base   = number<br>    name   = string<br>    weight = number<br>  }))</pre> | `[]` | no |
| <a name="input_cluster_arn"></a> [cluster\_arn](#input\_cluster\_arn) | ARN of the ECS cluster on which to run the service. If a cluster is not specified, the default cluster is assumed. | `string` | `null` | no |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | (Optional) Upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment. Not valid when using the DAEMON scheduling strategy. | `number` | `200` | no |
| <a name="input_deployment_minimum_percent"></a> [deployment\_minimum\_percent](#input\_deployment\_minimum\_percent) | (Optional) Lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment. | `number` | `100` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Number of instances of the task definition to place and keep running. | `number` | `0` | no |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | (Optional) Specifies whether to enable Amazon ECS Exec for the tasks within the service. | `bool` | `true` | no |
| <a name="input_health_check_grace_period"></a> [health\_check\_grace\_period](#input\_health\_check\_grace\_period) | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers. | `number` | `10` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL. | `string` | `"FARGATE"` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | Details of the load balancer to be associated to the service. | <pre>object({<br>    target_group_arn = string<br>    container_name   = string<br>    container_port   = number<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to give to the ECS Service. | `string` | n/a | yes |
| <a name="input_network_config"></a> [network\_config](#input\_network\_config) | Network configuration for the service. | <pre>object({<br>    subnets          = list(string)<br>    security_groups  = list(string)<br>    assign_public_ip = optional(bool)<br>  })</pre> | `null` | no |
| <a name="input_propagate_tags"></a> [propagate\_tags](#input\_propagate\_tags) | Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK\_DEFINITION. | `string` | `"TASK_DEFINITION"` | no |
| <a name="input_service_registry"></a> [service\_registry](#input\_service\_registry) | The details of the service discovery registry to associate with this service. | <pre>object({<br>    arn            = string<br>    port           = optional(number)<br>    container_port = optional(number)<br>    container_name = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the target group. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(any)` | `null` | no |
| <a name="input_task_definition_arn"></a> [task\_definition\_arn](#input\_task\_definition\_arn) | Family and revision (family:revision) or full ARN of the task definition to be run in the service. Required unless using the EXTERNAL deployment controller. If a revision is not specified, the latest ACTIVE revision is used. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | ECS service attributes |

variable "name" {
  description = "Name to give to the ECS Service."
  type        = string
}

variable "cluster_arn" {
  description = "ARN of the ECS cluster on which to run the service. If a cluster is not specified, the default cluster is assumed."
  default     = null
  type        = string
}

variable "task_definition_arn" {
  description = "Family and revision (family:revision) or full ARN of the task definition to be run in the service. Required unless using the EXTERNAL deployment controller. If a revision is not specified, the latest ACTIVE revision is used."
  default     = null
  type        = string
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running."
  default     = 0
  type        = number
}

variable "propagate_tags" {
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION."
  default     = "TASK_DEFINITION"
  type        = string
}

variable "enable_execute_command" {
  description = "(Optional) Specifies whether to enable Amazon ECS Exec for the tasks within the service."
  default     = false
  type        = bool
}

variable "launch_type" {
  description = "Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL."
  default     = "FARGATE"
  type        = string
}

variable "health_check_grace_period" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers."
  default     = 10
  type        = number
}

variable "deployment_maximum_percent" {
  description = "(Optional) Upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment. Not valid when using the DAEMON scheduling strategy."
  default     = 200
  type        = number
}

variable "deployment_minimum_percent" {
  description = "(Optional) Lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
  default     = 100
  type        = number
}

variable "service_registry" {
  description = "The details of the service discovery registry to associate with this service."
  default     = null
  type = object({
    arn            = string
    port           = optional(number)
    container_port = optional(number)
    container_name = optional(string)
  })
}

variable "network_config" {
  description = "Network configuration for the service."
  default     = null
  type = object({
    subnets          = list(string)
    security_groups  = list(string)
    assign_public_ip = optional(bool)
  })
}

variable "load_balancer" {
  description = "Details of the load balancer to be associated to the service."
  default     = null
  type = object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  })
}

variable "capacity_provider_strategy" {
  description = "(Optional) Capacity provider strategies to use for the service. Can be one or more. These can be updated without destroying and recreating the service only if force_new_deployment = true and not changing from 0 capacity_provider_strategy blocks to greater than 0, or vice versa. "
  default     = []
  type = list(object({
    base   = number
    name   = string
    weight = number
  }))
}

variable "tags" {
  description = "A map of tags to assign to the target group. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(any)
  default     = null
}

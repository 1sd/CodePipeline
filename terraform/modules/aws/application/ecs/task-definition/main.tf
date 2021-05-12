resource "aws_ecs_task_definition" "this" {
  family = "Ecs-${var.api_name}-TaskDefinition"
  container_definitions = templatefile(
    var.container_definitions_file,
    merge(var.container_definitions_environment, {
      container_name  = module.ecr_repository.aws_ecr_repository.name
      container_image = "${module.ecr_repository.aws_ecr_repository.repository_url}:latest"
    })
  )
  requires_compatibilities = [
    "EC2"
  ]
  network_mode       = var.network_mode
  task_role_arn      = var.role_arn
  execution_role_arn = var.role_arn

  lifecycle {
    create_before_destroy = true
  }
}

module "ecr_repository" {
  source = "../../ecr"
  name   = "${var.service}-${var.api_name}"
}

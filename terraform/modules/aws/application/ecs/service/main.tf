resource "aws_ecs_service" "this" {
  name            = "${var.prefix}-${var.api_name}-service"
  cluster         = var.cluster.arn
  desired_count   = var.desired_count
  task_definition = "${var.task_definition.family}:${max(var.task_definition.revision, data.aws_ecs_task_definition.this.revision)}"

  network_configuration {
    security_groups = module.security_groups.aws_security_groups.ids
    subnets         = module.subnets.aws_subnet_ids.ids
  }

  load_balancer {
    container_name   = "${var.service}-${var.api_name}-api"
    container_port   = 3000
    target_group_arn = module.load_balancer.aws_lb_target_group.arn
  }
}

module "security_groups" {
  source              = "../../../security/security_group"
  security_group_name = "${var.prefix}-${var.api_name}-sg"
  vpc_id              = var.vpc_id
}

module "subnets" {
  source = "../../../network/vpc"
  vpc_id = var.vpc_id
}

module "load_balancer" {
  source            = "../../load_balancer"
  target_group_name = "${var.prefix}-${var.api_name}-tgp"
}

data "aws_ecs_task_definition" "this" {
  task_definition = var.task_definition.family
}

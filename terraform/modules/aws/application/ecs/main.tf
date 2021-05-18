resource "aws_ecs_cluster" "this" {
  name               = "${var.service}-cluster"
  capacity_providers = ["FARGATE"]
}

resource "aws_cloudwatch_log_group" "this" {
  for_each   = var.api_list
  name       = "/ecs/${each.value}"
  depends_on = [aws_ecs_cluster.this]
}

resource "aws_ecs_task_definition" "this" {
  for_each = var.api_list
  family   = "${each.value}-TaskDefinition"
  container_definitions = templatefile(
    "../modules/aws/application/ecs/container-definitions/main.json",
    merge(var.container_definitions_environment, {
      container_name  = var.ecr[each.key].name
      container_image = "${var.ecr[each.key].repository_url}:latest"
    })
  )
  requires_compatibilities = [
    var.launch_type
  ]
  network_mode       = var.network_mode
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = var.execution_role_arn

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_cloudwatch_log_group.this]
}

data "aws_ecs_task_definition" "this" {
  for_each        = var.api_list
  task_definition = aws_ecs_task_definition.this[each.key].family
  depends_on      = [aws_ecs_task_definition.this]
}


resource "aws_ecs_service" "this" {
  for_each        = var.api_list
  name            = "${each.value}-service"
  cluster         = aws_ecs_cluster.this.arn
  desired_count   = var.desired_count
  launch_type     = var.launch_type
  task_definition = "${aws_ecs_task_definition.this[each.key].family}:${max(aws_ecs_task_definition.this[each.key].revision, data.aws_ecs_task_definition.this[each.key].revision)}"

  network_configuration {
    security_groups  = data.aws_security_groups.this.ids
    subnets          = data.aws_subnet_ids.this.ids
    assign_public_ip = true
  }

  // TODO 必要であれば追加
  //  load_balancer {
  //    container_name   = var.ecr[each.key].name
  //    container_port   = 3000
  //    target_group_arn = module.load_balancer.aws_lb_target_group.arn
  //  }
}

data "aws_security_groups" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet_ids" "this" {
  vpc_id = var.vpc_id
  tags = {
    Tier = "public"
  }
}

// TODO 必要であれば追加
//module "load_balancer" {
//  source            = "../../load_balancer"
//  target_group_name = "${var.prefix}-${var.api_name}-tgp"
//}

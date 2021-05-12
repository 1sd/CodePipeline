resource "aws_cloudwatch_event_rule" "this" {
  name                = var.name
  schedule_expression = var.schedule_expression
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "this" {
  target_id = var.cluster.cluster_name
  rule      = aws_cloudwatch_event_rule.this.name
  arn       = var.cluster.arn
  role_arn  = var.role_arn

  ecs_target {
    task_definition_arn = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:task-definition/${var.task_definition.family}:${max(var.task_definition.revision, data.aws_ecs_task_definition.this.revision)}"
    task_count          = 1
    launch_type         = "EC2"
  }

  input = <<DOC
  %{if var.container_name != ""}
    {
      "containerOverrides": [
        {
          "name": "${var.container_name}",
          "environment": [
            {
              "name": "IDENTIFY_TASK",
              "value": "/usr/share/logstash/pipeline2"
            }
          ]
        }
      ]
    }
  %{else}
    {}
  %{endif}
  DOC
}

data "aws_ecs_task_definition" "this" {
  task_definition = var.task_definition.family
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

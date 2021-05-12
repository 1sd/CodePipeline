data "aws_lb_target_group" "this" {
  name = var.target_group_name
}

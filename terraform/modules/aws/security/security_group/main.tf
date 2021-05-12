data "aws_security_groups" "this" {
  filter {
    name   = "group-name"
    values = [var.security_group_name]
  }
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

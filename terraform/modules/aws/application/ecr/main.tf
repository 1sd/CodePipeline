data "aws_ecr_repository" "this" {
  name = "${var.name}-api"
}

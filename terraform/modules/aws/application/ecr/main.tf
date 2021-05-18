resource "aws_ecr_repository" "this" {
  for_each = var.api_list
  name     = each.value
}

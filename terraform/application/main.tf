locals {
  test = "${var.env}-service"
}

module "ecs_cluster" {
  source = ""
}
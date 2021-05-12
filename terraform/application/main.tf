locals {
  prefix                 = "${var.env}-${var.service}"
}

module "ecs_cluster" {
  source = ""
}
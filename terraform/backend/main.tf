locals {
  prefix = "${var.env}-${var.service}"
  tags = {
    Service = var.service
    Env     = var.env
  }
}

module "s3" {
  source     = "../modules/backend/s3"
  prefix     = local.prefix
  tags       = local.tags
  account_id = data.aws_caller_identity.self.account_id
}

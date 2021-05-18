locals {
  prefix = "${var.env}-${var.service}"
  subnets = {
    1 = {
      cidr_block        = "10.0.1.0/24",
      availability_zone = "ap-northeast-1a",
    },
    //    2 = {
    //      cidr_block = "10.0.3.0/24",
    //      availability_zone = "ap-northeast-1d",
    //    }
  }
  api_list = {
    1 = "${var.service}1"
  }
}

module "vpc" {
  source  = "../modules/aws/network/vpc"
  service = var.service
  subnets = local.subnets
}

module "role" {
  source     = "../modules/aws/security/iam_role"
  depends_on = [module.vpc]
}

module "ecr" {
  api_list   = local.api_list
  source     = "../modules/aws/application/ecr"
  depends_on = [module.role]
}

module "ecs" {
  api_list           = local.api_list
  source             = "../modules/aws/application/ecs"
  service            = var.service
  execution_role_arn = module.role.ecsTaskExecutionRole.arn
  ecr                = module.ecr.aws_ecr_repository
  vpc_id             = module.vpc.id
  depends_on         = [module.ecr]
}

variable "service" {}

variable "api_list" {}

variable "execution_role_arn" {}

variable "ecr" {}

variable "vpc_id" {}

variable "container_definitions_environment" {
  default = {}
}

variable "network_mode" {
  default = "awsvpc"
}

variable "cpu" {
  default = 256
}

variable "memory" {
  default = 512
}

variable "desired_count" {
  default = 1
}

variable "launch_type" {
  default = "FARGATE"
}

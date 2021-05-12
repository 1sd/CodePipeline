variable "container_definitions_file" {
  default = "../../modules/aws/application/ecs/task-definition/container-definitions/main.json"

}
variable "network_mode" {
  default = "awsvpc"
}

variable "api_name" {}
variable "container_definitions_environment" {}
variable "role_arn" {}
variable "service" {}

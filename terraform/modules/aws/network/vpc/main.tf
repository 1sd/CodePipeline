data "aws_subnet_ids" "this" {
  vpc_id = var.vpc_id
  tags = {
    Tier = "Private"
  }
}

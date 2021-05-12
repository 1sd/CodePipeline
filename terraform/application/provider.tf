terraform {
  required_version = "~> 0.15.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  backend "s3" {
    # ここでvariable使えないのでハードコーディング
    region = "ap-northeast-1"
    bucket = "dev-codepipeline-tfstate-084081127834"
    key = "tfstate"

    dynamodb_table = "dev-codepipeline-tfstate"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

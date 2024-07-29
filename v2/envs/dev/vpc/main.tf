provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../../modules/vpc"

  env        = "dev-master"
  cidr_block = "10.0.0.0/16"
}
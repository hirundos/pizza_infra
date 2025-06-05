terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id = module.vpc.vpc_id
  public_a_snet_id = module.vpc.public_subnet_ids.a
  private_a_snet_id = module.vpc.public_subnet_ids.a
}
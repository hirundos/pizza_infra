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

  vpc_id            = module.vpc.vpc_id
  public_a_snet_id  = module.vpc.public_subnet_ids[0]
  private_a_snet_id = module.vpc.private_subnet_ids[0]
}

module "rds" {
  source = "./modules/rds"

  db_snet_grp          = module.vpc.db_subnet_group
  db_security_group_id = module.ec2.db_security_group_id
}


module "eks" {
  source = "./modules/eks"

  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_db_sg_id       = module.ec2.ec2-to-db-sg_id
  eks_node_sg_id     = module.ec2.eks_node_sg_id
  eks_shared_sg_id   = module.ec2.eks_share_sg_id
  nat_gw = module.vpc.nat-gw
  vpc_id = module.vpc.vpc_id
}
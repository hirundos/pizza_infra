terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "ap-northeast-2"
}

provider "kubernetes" {
  host                   = module.eks.aws_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(module.eks.aws_eks_cluster.certificate_authority[0].data)
  token                  = module.eks.aws_eks_cluster_auth.token
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id            = module.vpc.vpc_id
  public_a_snet_id  = module.vpc.public_subnet_ids[0]
  private_a_snet_id = module.vpc.public_subnet_ids[0]
}

module "rds" {
  source = "./modules/rds"

  db_snet_grp = module.vpc.db_subnet_group
  db_security_group_id = module.ec2.db_security_group_id
}


module "eks" {
  source = "./modules/eks"

  private_subnet_ids = module.vpc.public_subnet_ids

  providers = {
    kubernetes = kubernetes
  }
}
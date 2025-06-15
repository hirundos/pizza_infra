provider "google" {
  project = "kdt1-project-gks"
  region  = "asia-northeast3"
}

#$env:GOOGLE_APPLICATION_CREDENTIALS = "C:\Users\user\Downloads\kdt1-project-gks-7659702815f3.json"

module "vpc" {
  source = "./modules/vpc"
}

module "rdb" {
  source = "./modules/rdb"

  pz_vpc = module.vpc.pz_vpc
  vpc_connection = module.vpc.vpc_connection
  
}


module "gke" {
  source = "./modules/gke"
  pz_vpc = module.vpc.pz_vpc
  pz_snet = module.vpc.pz_snet
  vpc_connection = module.vpc.vpc_connection
    
}
locals {
  vpc_name = "pz-vpc"
}

locals {
  igw_name = "pz-igw"
}

locals {
  az_a = "ap-northeast-2a"
}

locals {
  az_c = "ap-northeast-2c"
}

locals {
  vpc_cidr = "172.16.0.0/16"
}

locals {
  public_subnet_a_cidr = "172.16.1.0/24"
}
locals {
  public_subnet_c_cidr = "172.16.2.0/24"
}
locals {
  private_subnet_a_cidr = "172.16.3.0/24"
}
locals {
  private_subnet_c_cidr = "172.16.4.0/24"
}
locals {
  private_subnet_db_a_cidr = "172.16.100.0/24"
}
locals {
  private_subnet_db_c_cidr = "172.16.101.0/24"
}
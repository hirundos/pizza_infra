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

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "public_subnet_a_cidr" {
  default = "172.16.1.0/24"
}
variable "public_subnet_c_cidr" {
  default = "172.16.2.0/24"
}
variable "private_subnet_a_cidr" {
  default = "172.16.3.0/24"
}
variable "private_subnet_c_cidr" {
  default = "172.16.4.0/24"
}

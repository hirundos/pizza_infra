
locals {
  ec2_bastion_nm = "bastion_instance"
}

locals {
  my_keypair = "ay-key"
}

locals {
  my_ip = "1.212.30.182/32"
}

locals  {
  amazon_img = "ami-0e967ff96936c0c0c"
}

variable "vpc_id" {
  
}

variable "public_a_snet_id" {
  
}

variable "private_a_snet_id" {
  
}
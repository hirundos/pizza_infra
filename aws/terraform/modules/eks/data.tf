data "aws_ami" "amazon_eks" {
  most_recent = true
  name_regex  = "^amazon-eks-node-"
  owners      = ["602401143452"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-1.32-v2025*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}
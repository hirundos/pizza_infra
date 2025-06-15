module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name = "eks-auto-mode"
  cluster_version = "1.31"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # EKS Control Plane 권한 자동
  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true
  enable_cluster_creator_admin_permissions = true
  enable_irsa = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose","system"]
  }

  eks_managed_node_groups = {
    with_lt = {
      launch_template = {
        id      = aws_launch_template.eks_nodes.id
        version = "$Latest"
      }
      desired_size   = 2
      instance_types = ["c6i.large"]
    }
  }
/*
  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["c6i.large"]
      capacity_type  = "ON_DEMAND"

      # Optional: node group IAM role override
      # iam_role_arn = ...
    }
  }
*/
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

}

resource "aws_launch_template" "eks_nodes" {
  name_prefix = "eks-nodes-"
  image_id      = data.aws_ami.amazon_eks.id
  instance_type = "c6i.large"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.eks_node_sg_id, var.ec2_db_sg_id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 50
      volume_type = "gp3"
    }
  }

}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "vpc-cni-irsa"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = {
    Name = "vpc-cni-irsa"
  }
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = module.eks.cluster_name
  addon_name   = "vpc-cni"
  resolve_conflicts = "OVERWRITE"

  service_account_role_arn = module.vpc_cni_irsa.iam_role_arn

  tags = {
    Name = "vpc-cni"
  }
}

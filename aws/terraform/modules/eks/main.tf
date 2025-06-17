module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name = "pizza-eks"
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
      create_launch_template = true
      desired_size   = 2
      instance_types = ["c6i.large"]

      vpc_security_group_ids=[
          module.eks.node_security_group_id,var.ec2_db_sg_id
        ]
    }
  }

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
      most_recent       = true
  }
    kube-proxy = {
      most_recent = true
  }
}


  tags = {
    Environment = "dev"
    Terraform   = "true"
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
  addon_version = "v1.19.5-eksbuild.3"
  resolve_conflicts = "OVERWRITE"

  service_account_role_arn = module.vpc_cni_irsa.iam_role_arn

  tags = {
    Name = "vpc-cni"
  }
}

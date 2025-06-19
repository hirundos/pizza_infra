output "eks_sg_id"{
    value = module.eks.node_security_group_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "alb_iam_arn" {
    value = module.aws_load_balancer_controller_irsa.iam_role_arn
}
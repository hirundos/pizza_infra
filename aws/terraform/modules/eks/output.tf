output "eks_sg_id"{
    value = module.eks.node_security_group_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}
/*
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([{
      rolearn  = aws_iam_role.eks_node_role.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }])
  }

  depends_on = [aws_eks_node_group.node_group]
}
*/
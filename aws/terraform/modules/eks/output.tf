output "aws_eks_cluster" {
  value = aws_eks_cluster.main
}

output "aws_eks_cluster_auth" {
  value = data.aws_eks_cluster_auth.main
}
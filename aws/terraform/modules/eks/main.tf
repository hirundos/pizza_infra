resource "aws_eks_cluster" "main" {
  name     = "pizza-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  version = "1.32"

  tags = {
    Name = "pizza-eks-cluster"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy
  ]
}

#노드 그룹
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "pizza-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  disk_size = 30 # GB

  tags = {
    Name = "Node"
  }

  # 클러스터 생성 후, 노드 그룹 생성 시 의존성 명시
  depends_on = [
    aws_eks_cluster.main,
    aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy
  ]
}



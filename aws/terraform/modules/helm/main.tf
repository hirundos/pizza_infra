resource "kubernetes_service_account" "alb_controller" {
  provider = kubernetes
  
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
  }
}

resource "helm_release" "alb_controller" {
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  name    = "aws-load-balancer-controller"
  chart   = "aws-load-balancer-controller"
  version = "1.5.5"
  
  values = [templatefile("${path.module}/alb_values.tftpl", {
    cluster_name     = "pizza-eks"
    region           = "ap-northeast-2"
    service_account  = "aws-load-balancer-controller"
    vpc_id           = var.vpc_id
  })]
  depends_on = [kubernetes_service_account.alb_controller]
}


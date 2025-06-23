resource "kubernetes_ingress_v1" "web_ingress" {
  metadata {
    name      = "web-ingress"
    namespace = var.namespace

    annotations = {
      "alb.ingress.kubernetes.io/scheme"                  = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"             = "ip"
      "alb.ingress.kubernetes.io/backend-protocol"        = "HTTP"
      "alb.ingress.kubernetes.io/listen-ports"            = "[{\"HTTP\": 80}]"
      "alb.ingress.kubernetes.io/group.name"              = "default"
      "alb.ingress.kubernetes.io/load-balancer-attributes"= "idle_timeout.timeout_seconds=60"
      "alb.ingress.kubernetes.io/healthcheck-path"        = "/"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.web_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

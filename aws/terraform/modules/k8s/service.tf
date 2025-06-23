resource "kubernetes_service" "web_service" {
  metadata {
    name      = "web-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "web"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "was_service" {
  metadata {
    name      = "was-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "was"
    }

    port {
      port        = 3000
      target_port = 3000
    }

    type = "ClusterIP"
  }
}

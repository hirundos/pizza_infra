resource "kubernetes_deployment" "was" {
  metadata {
    name      = "was"
    namespace = var.namespace
    labels = {
      app = "was"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "was"
      }
    }

    template {
      metadata {
        labels = {
          app = "was"
        }
      }

      spec {
        container {
          name  = "was"
          image = "424215643714.dkr.ecr.ap-northeast-2.amazonaws.com/pizza/pizza-was:1.0"

          port {
            container_port = 3000
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }

            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          env_from {
            config_map_ref {
              name = "was-config"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "web" {
  metadata {
    name      = "web"
    namespace = var.namespace
    labels = {
      app = "web"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "web"
      }
    }

    template {
      metadata {
        labels = {
          app = "web"
        }
      }

      spec {
        container {
          name  = "web"
          image = "424215643714.dkr.ecr.ap-northeast-2.amazonaws.com/pizza/pizza-web:1.0"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }

            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

        }
      }
    }
  }
}
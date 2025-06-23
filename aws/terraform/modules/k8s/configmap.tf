resource "kubernetes_config_map" "was_config" {
  metadata {
    name      = "was-config"
    namespace = var.namespace
  }

  data = {
    DB_PORT = "5432"
    DB_HOST  = var.db_endpoint
    DB_USER = "postgres"
    DB_DATABASE = "pizza"
    DB_PASSWORD = "pizzastore"
    SECRET_KEY = "714e6b8f29c1a3e8dd420bf98df124bc1a79b04c4e3aaf624d5c318a7b8e0a5db99fbd9e8d1f7c6c29a8f374628cbec98dfb01a4567edcfbfa38d2c1f7ab7bc2"
  }
}

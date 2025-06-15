resource "google_sql_database_instance" "private_instance" {
  name             = "ay-pgsql"
  region           = var.region
  database_version = "POSTGRES_17"
  
  settings {
    tier = "db-f1-micro"
    edition          = "ENTERPRISE"
    
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.pz_vpc.id
    }

    backup_configuration {
      enabled = false
    }

    deletion_protection_enabled = false
  }

  depends_on = [var.vpc_connection]
}

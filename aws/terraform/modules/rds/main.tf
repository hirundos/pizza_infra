resource "aws_db_instance" "postgres_from_snapshot" {
  identifier             = "pizza-postgres-db"
  instance_class         = "db.t3.micro"
  engine                 = "postgres"
  engine_version         = "17"
  snapshot_identifier    = "pg-db-snapshot"
  db_subnet_group_name   = var.db_snet_grp
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  storage_encrypted      = true
  password = "pizzastore"


  tags = {
    Name = "pizza-db"
  }
}

resource "aws_db_instance" "postgres_from_snapshot" {
  identifier             = "pizza-postgres-db"
  instance_class         = "db.t3.micro"
  engine                 = "postgres"
  engine_version         = "17"
  snapshot_identifier    = "pz-snap"
  db_subnet_group_name   = var.db_snet_grp
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  storage_encrypted      = false
  password = "pizzastore"

lifecycle {
  ignore_changes = [snapshot_identifier, password, engine_version]
}

  tags = {
    Name = "pizza-db"
  }
}

data "aws_kms_secrets" "creds" {
  secret {
    name = "db"
    payload = file("${path.module}/db-creds.yml.encrypted")
  }
}
locals {
  db_creds = yamldecode(data.aws_kms_secrets.creds.plaintext["db"])
}

resource "aws_db_instance" "mydb" {
  db_name = "mydb"
  engine = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"
  allocated_storage = 10

  publicly_accessible = true
  skip_final_snapshot = true

  username = local.db_creds.username
  password = local.db_creds.password
}

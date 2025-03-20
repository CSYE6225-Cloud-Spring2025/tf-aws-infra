resource "aws_db_instance" "rds_mysql" {
  identifier             = "csye6225"
  engine                 = "mysql"
  engine_version         = "8.0"
  db_name                = var.rds_db_name
  username               = var.rds_username
  password               = local.rds_password
  instance_class         = var.rds_instance_class
  storage_type           = "gp2"
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  parameter_group_name   = aws_db_parameter_group.rds_parameter_group.name
  multi_az               = false
  publicly_accessible    = false
  deletion_protection    = false
  skip_final_snapshot    = true
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  name   = "rds-parameter-group"
  family = "mysql8.0"
  parameter {
    name  = "wait_timeout"
    value = "60"
  }
  parameter {
    name  = "max_connections"
    value = "50"
  }
}

resource "random_password" "db_password" {
  length  = 16
  upper   = true
  lower   = true
  numeric = true
  special = false
}

locals {
  rds_password = random_password.db_password.result
}
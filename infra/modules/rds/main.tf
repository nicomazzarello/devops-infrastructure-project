module "rds_weatherapp" {
  source  = "terraform-aws-modules/rds-aurora/aws"

  name           = var.cluster_name
  database_name  = var.db_name
  engine         = "aurora-postgresql"
  engine_version = "14.5"
  instance_class = "db.r6g.large"
  instances = {
    one   = {}
    two   = {}
    three = {}
  }
  publicly_accessible      = false
  autoscaling_enabled      = true
  autoscaling_min_capacity = 2
  autoscaling_max_capacity = 5

  master_username         = var.master_username
  master_password         = random_password.db_password.result
  vpc_id                  = var.vpc_id
  vpc_security_group_ids  = [aws_security_group.db.id]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  subnets = var.subnet_ids

  snapshot_identifier     = "rds:aurora-postgresql-weatherapp"
  backup_retention_period = 14

  security_group_rules = {
    ex1 = {
      source_security_group_id = aws_security_group.db.id
    }
  }

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10
  deletion_protection = true

  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = {
    Environment = "development"
    Terraform   = "true"
    Owner       = "Nicolas Kiu"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "db" {
  name        = "aurora-db-sg"
  description = "Allow EKS access"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # limit to VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "aurora-master-credentials"
  description = "Master credentials for Aurora PostgreSQL"
}

resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    master_username = module.rds_weatherapp.cluster_master_username
    master_password = module.rds_weatherapp.cluster_master_password
    writer_endpoint = module.rds_weatherapp.cluster_endpoint
    reader_endpoint = module.rds_weatherapp.cluster_reader_endpoint
  })
}

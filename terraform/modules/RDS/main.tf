resource "aws_security_group" "rds_security_group" {
  name        = "rds-${local.workspace}-security-group"
  description = "HTTP"
  vpc_id      = data.aws_vpc.vpc.id

  # ingress {
  #   from_port   = var.DB_PORT
  #   to_port     = var.DB_PORT
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [ var.rds_sg ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage      = var.db_allocated_storage
  engine                 = var.db_engine
  instance_class         = var.db_instance_class
  engine_version         = var.db_engine_version
  name                   = var.DB_NAME
  username               = var.DB_USERNAME
  password               = var.DB_PASSWORD
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  skip_final_snapshot    = true
  publicly_accessible    = true
}

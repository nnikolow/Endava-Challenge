# RDS Subnet Configuration
resource "aws_db_subnet_group" "rds_instance_subnet" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.db_subnet

  tags = {
    Name = "Endava-RDS-Subnet-Group"
  }
}


# RDS Security Group Configuration
resource "aws_security_group" "rds_instance_sg" {
  vpc_id = var.vpc

  ingress {
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [var.ec2_security_group]
    }

    tags = {
      Name = "Endava-RDS-SecurityGroup"
  }
}


# RDS Configuration
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  identifier           = var.db_identifier
  db_subnet_group_name = aws_db_subnet_group.rds_instance_subnet.id
  storage_type         = var.db_storage_type
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  publicly_accessible  = false
  skip_final_snapshot  = true
  # service failover
  # multi_az                = true
  # backup_retention_period = 14
  # backup_window           = "23:00-01:00"
  # maintenance_window      = "fri:04:00-fri:04:30"

  tags = {
    Name = "Endava-RDS"
  }
}
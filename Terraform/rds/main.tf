provider "aws" {
  region = "us-west-2"
}

resource "aws_db_instance" "IE-sql" {
  instance_class          = "${var.db_instance}"
  engine                  = "mysql"
  engine_version          = "5.7"
  multi_az                = true
  storage_type            = "standard"
  allocated_storage       = 10
  name                    = "ierds"
  username                = "admin"
  password                = "IEadmin022420"
  apply_immediately       = "true"
  backup_retention_period = 30
  backup_window           = "10:00-11:00"
  db_subnet_group_name    = "${aws_db_subnet_group.IE-rds-db-subnet.name}"
  vpc_security_group_ids  = ["${aws_security_group.IE-rds-sg.id}"]
}

resource "aws_db_subnet_group" "IE-rds-db-subnet" {
  name       = "ie-rds-db-subnet"
  subnet_ids = ["${var.rds_subnet1}", "${var.rds_subnet2}"]
}

resource "aws_security_group" "IE-rds-sg" {
  name   = "ie-rds-sg"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "IE-rds-sg-rule" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = "${aws_security_group.IE-rds-sg.id}"
  to_port           = 3306
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_rule" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.IE-rds-sg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

/*
data "aws_kms_secret" "rds" {
  secret {
    name = "db-password"
    payload = "hash"
  }
}
*/


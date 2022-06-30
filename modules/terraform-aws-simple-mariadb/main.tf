resource "aws_db_instance" "default" {
  allocated_storage      = 10
  identifier             = "tf-simple-mariadb"
  engine                 = "mariadb"
  engine_version         = "10.6"
  instance_class         = "db.t4g.micro"
  name                   = "mariadb"
  username               = var.username
  password               = var.password
  parameter_group_name   = "default.mariadb10.6"
  skip_final_snapshot    = true
  db_subnet_group_name   = var.db_subnet_group
  vpc_security_group_ids = [aws_security_group.mariadb.id]
}

resource "aws_security_group" "mariadb" {
  description = "Security group to allow public inbound traffic to MariaDB"
  name        = "MariaDB"
  vpc_id      = var.vpc
}

resource "aws_security_group_rule" "inbound_mariadb" {
  type              = "ingress"
  description       = "allow inbound 3306"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.mariadb.id
}

resource "aws_security_group_rule" "outbound_mariadb" {
  type              = "egress"
  description       = "allow outbound all"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mariadb.id
}
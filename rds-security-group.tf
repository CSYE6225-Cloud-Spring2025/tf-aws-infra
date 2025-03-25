resource "aws_security_group" "rds_security_group" {
  name        = "rds-security-group"
  description = "RDS instance security group"
  vpc_id      = aws_vpc.test_vpc.id

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    description = "Outgoing access"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    description     = "Incoming access"
    security_groups = [aws_security_group.webapp_security_group.id]
  }
}
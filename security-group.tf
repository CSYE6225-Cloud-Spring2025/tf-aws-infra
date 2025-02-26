resource "aws_security_group" "webapp_security_group" {
  name        = "webapp-security-group"
  description = "webapp EC2 instance security group"
  vpc_id      = aws_vpc.test_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outgoing access"
  }
}

resource "aws_security_group_rule" "webapp_ingress_rules" {
  count             = 4
  type              = "ingress"
  from_port         = [22, 80, 443, var.webapp_port][count.index]
  to_port           = [22, 80, 443, var.webapp_port][count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webapp_security_group.id
  description       = "Incoming access to port ${[22, 80, 443, var.webapp_port][count.index]}"
}
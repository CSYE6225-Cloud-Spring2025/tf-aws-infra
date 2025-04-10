resource "aws_security_group" "webapp_security_group" {
  name        = "webapp-security-group"
  description = "webapp EC2 instance security group"
  vpc_id      = aws_vpc.test_vpc.id

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    description = "Outgoing access"
  }
}

resource "aws_security_group_rule" "webapp_ingress_rules" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = var.webapp_port
  to_port                  = var.webapp_port
  security_group_id        = aws_security_group.webapp_security_group.id
  source_security_group_id = aws_security_group.load_balancer_security_group.id
  description              = "Incoming access to port ${var.webapp_port}"
}
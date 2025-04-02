resource "aws_security_group" "load_balancer_security_group" {
  name        = "load_balancer-security-group"
  description = "load_balancer security group"
  vpc_id      = aws_vpc.test_vpc.id

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    description = "Outgoing access"
  }
}

resource "aws_security_group_rule" "load_balancer_ingress_rules" {
  count             = 2
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = [80, 443][count.index]
  to_port           = [80, 443][count.index]
  security_group_id = aws_security_group.load_balancer_security_group.id
  description       = "Incoming access to port ${[80, 443][count.index]}"
}
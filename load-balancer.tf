resource "aws_lb" "webapp_load_balancer" {
  name               = "webapp-load-balancer"
  load_balancer_type = "application"
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]
  security_groups    = [aws_security_group.load_balancer_security_group.id]
  tags = {
    Name = "webapp-load-balancer"
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_lb.webapp_load_balancer.dns_name
    zone_id                = aws_lb.webapp_load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_lb_listener" "webapp_listener" {
  load_balancer_arn = aws_lb.webapp_load_balancer.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_target_group.arn
  }
}

resource "aws_lb_target_group" "webapp_target_group" {
  name     = "webapp-target-group"
  protocol = "HTTP"
  port     = var.webapp_port
  vpc_id   = aws_vpc.test_vpc.id
  health_check {
    interval            = 60
    path                = "/healthz"
    matcher             = "200"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
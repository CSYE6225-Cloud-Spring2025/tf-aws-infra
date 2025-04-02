resource "aws_autoscaling_group" "webapp_autoscaling_group" {
  name = "webapp-autoscaling-group"
  launch_template {
    id      = aws_launch_template.webapp_template.id
    version = "$Latest"
  }
  min_size            = 3
  desired_capacity    = 3
  max_size            = 5
  vpc_zone_identifier = [for subnet in aws_subnet.public_subnet : subnet.id]
  health_check_type   = "ELB"
  default_cooldown    = 60
  target_group_arns   = [aws_lb_target_group.webapp_target_group.arn]
  tag {
    key                 = "AutoScalingGroup"
    value               = "webapp-autoscaling-group"
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "webapp-autoscaling-group-instance"
    propagate_at_launch = true
  }
}
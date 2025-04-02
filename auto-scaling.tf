resource "aws_cloudwatch_metric_alarm" "webapp_low_cpu" {
  alarm_name          = "webapp-low-cpu-usage"
  alarm_description   = "Scale down instances when CPU utilization < 1%"
  metric_name         = "CPUUtilization"
  comparison_operator = "LessThanThreshold"
  threshold           = 1
  period              = 60
  evaluation_periods  = 2
  statistic           = "Average"
  namespace           = "AWS/EC2"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_autoscaling_group.name
  }
  alarm_actions = [aws_autoscaling_policy.webapp_scale_down.arn]
}

resource "aws_autoscaling_policy" "webapp_scale_down" {
  name                   = "webapp-scale-down-policy"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_autoscaling_group.name
}

resource "aws_cloudwatch_metric_alarm" "webapp_high_cpu" {
  alarm_name          = "webapp-high-cpu-usage"
  alarm_description   = "Scale down instances when CPU utilization > 1%"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 3
  period              = 60
  evaluation_periods  = 2
  statistic           = "Average"
  namespace           = "AWS/EC2"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_autoscaling_group.name
  }
  alarm_actions = [aws_autoscaling_policy.webapp_scale_up.arn]
}

resource "aws_autoscaling_policy" "webapp_scale_up" {
  name                   = "webapp-scale-up-policy"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_autoscaling_group.name
}
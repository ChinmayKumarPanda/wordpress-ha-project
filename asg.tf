resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  min_size         = 3
  max_size         = 5

  vpc_zone_identifier = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  target_group_arns = [aws_lb_target_group.tg.arn]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
}

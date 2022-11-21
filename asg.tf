resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.web.name}-asg"
  min_size             = 2
  desired_capacity     = 2
  max_size             = 4
  health_check_type    = "ELB"
  load_balancers = [aws_elb.web_elb.id]
  vpc_zone_identifier       = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  launch_configuration = "${aws_launch_configuration.web.name}"
  enabled_metrics = [
      "GroupMinSize",
      "GroupMaxSize",
      "GroupDesiredCapacity",
      "GroupInServiceInstances",
      "GroupTotalInstances"
    ]
  metrics_granularity = "1Minute"
  # Required to redeploy without an outage.
    lifecycle {
      create_before_destroy = true
    }
  tag {
      key                 = "Name"
      value               = "tomcat"
      propagate_at_launch = true
    }
}
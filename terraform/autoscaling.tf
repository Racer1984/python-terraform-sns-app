resource "aws_launch_configuration" "sns-app-launchconfig" {
  name_prefix          = "sns-app-launchconfig-"
  image_id             = "ami-0cc4469d796e1726f"
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.allow_any_ssh_and_www_to_ec2.id]

  iam_instance_profile = aws_iam_instance_profile.AllowSNS_AllowSSM-instanceprofile.name

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "sns-app-autoscaling" {
  name = "${aws_launch_configuration.sns-app-launchconfig.name}-asg"

  vpc_zone_identifier  = [aws_subnet.public_net.id]
  launch_configuration = aws_launch_configuration.sns-app-launchconfig.name
  min_size             = 1
  max_size             = 2
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "sns-app ec2 instance"
    propagate_at_launch = true
  }
}

resource "aws_lb" "sns-app-alb" {
  name               = "sns-app-alb"
  internal           = false
  security_groups    = [aws_security_group.allow_ssh_and_www_to_alb.id]
  subnets            = [aws_subnet.public_net.id, aws_subnet.private_net.id]

  tags = {
    Environment = "Test"
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "alb-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.pysns.id
  tags = {
    name = "alb_target_group"
  }
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = true
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = 80
    matcher             = "200-399"
  }
}

resource "aws_autoscaling_attachment" "alb_autoscale" {
  alb_target_group_arn   = aws_lb_target_group.alb_target_group.arn
  autoscaling_group_name = aws_autoscaling_group.sns-app-autoscaling.id
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.sns-app-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    type             = "forward"
  }
}
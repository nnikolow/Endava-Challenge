# EC2 Security Group Configuration
resource "aws_security_group" "endava-ec2-sg" {
  vpc_id = var.vpc

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  } 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }    

  tags = {
     Name = "Endava-EC2-SecurityGroup"
  }
}


# Create the launch configuration for the autoscaling group
resource "aws_launch_configuration" "ec2" {
  image_id = "ami-0a261c0e5f51090b1"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.endava-ec2-sg.id]
  associate_public_ip_address = true
  user_data = <<EOF
    #!/bin/bash
    sudo yum -y install httpd && sudo systemctl start httpd
    echo '<h1><center>web server exposed</center></h1>' > index.html
    sudo mv index.html /var/www/html/index.html
  EOF
}


# Create the Auto Scaling group
resource "aws_autoscaling_group" "ec2-autoscaling" {
  launch_configuration = aws_launch_configuration.ec2.name # references ec2 launch configuration
  min_size = 1
  max_size = 2
  desired_capacity = 1
  vpc_zone_identifier = [var.subnet_id[0]]
  target_group_arns = [var.alb_target_group_arn] # attaches the autoscaling group to alb 
  tag {
    key = "Name"
    value = "endava-ec2"
    propagate_at_launch = true
  }
}


# Attach Scale-up policy to the Auto Scaling group
resource "aws_autoscaling_policy" "scale-up-policy" {
  name = "example-scale-up"
  adjustment_type = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.ec2-autoscaling.name # autoscaling group
  policy_type = "SimpleScaling"
  scaling_adjustment = 1
}


# Create the CloudWatch alarm for high CPU usage
resource "aws_cloudwatch_metric_alarm" "example" {
  alarm_name = "High-cpu-usage"
  alarm_description = "Sends a message when the average CPU usage is above 70% for 2 periods of 60 seconds"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "70"
  alarm_actions = [aws_autoscaling_policy.scale-up-policy.arn] # autoscaling policy
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2-autoscaling.name
  }
}


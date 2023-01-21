# Security Group for the ALB
resource "aws_security_group" "endava-alb-sg" {
  vpc_id = var.vpc

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  } 

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }   

  tags = {
     Name = "Endava-ALB-SecurityGroup"
  }
}


# Load Balancer Configuration
resource "aws_lb" "endava-alb" {
  name                = "endava-lb"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.endava-alb-sg.id]
  subnets             = var.subnet_ids

  tags = {
    Name = "Endava-ALB"
  }
}

# Load Balancer Target Group
resource "aws_lb_target_group" "endava-alb-tg" {
  name      = "endava-lb-tg"
  port      = 80
  protocol  = "HTTP"
  vpc_id    = var.vpc

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "Endava-ALB-TargetGroup"
  }
}

# Load Balancer Listener Configuration
resource "aws_lb_listener" "endava-alb-listener" {
  load_balancer_arn = aws_lb.endava-alb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.endava-alb-tg.arn
  }

  tags = {
    Name = "Endava-ALB-Listener"
  }
}
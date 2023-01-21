# output for referencing in the ec2 aws_autoscaling_group.target_group_arns
output "alb_target_group_arn" {
  value = aws_lb_target_group.endava-alb-tg.arn
}
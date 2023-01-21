output "ec2_security_group" {
  value = aws_security_group.endava-ec2-sg.id
}

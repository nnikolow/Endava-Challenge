output "vpc_id" {
  value = aws_vpc.endava-vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.endava-public-subnets[*].id
}

output "private_subnet_id" {
  value = aws_subnet.endava-public-subnets[*].id
}
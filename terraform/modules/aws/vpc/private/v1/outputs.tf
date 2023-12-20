output "vpc_id" {
  value = aws_vpc.private_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}
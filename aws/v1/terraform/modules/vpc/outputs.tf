output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = {
    a = aws_subnet.public_a.id
    c = aws_subnet.public_c.id
  }
}

output "private_subnet_ids" {
  value = {
    a = aws_subnet.private_a.id
    c = aws_subnet.private_c.id
  }
}

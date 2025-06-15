output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_a.id,
  aws_subnet.public_c.id]

}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id
  ]
}

output "db_subnet_group" {
  value = aws_db_subnet_group.postgres.name
}

output "nat-gw" {
  value = aws_nat_gateway.nat
}
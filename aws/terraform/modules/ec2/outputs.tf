output "ec2_bastion_id" {
  value = aws_instance.bastion.id
}

output "ec2_bastion_sg_id" {
  value = aws_security_group.bastion-sg.id
}

output "db_security_group_id"{
  value = aws_security_group.db-sg.id
}
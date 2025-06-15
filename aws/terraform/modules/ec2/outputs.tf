
output "ec2_bastion_id" {
  value = aws_instance.bastion.id
}

output "ec2_bastion_sg_id" {
  value = aws_security_group.bastion-sg.id
}

output "db_security_group_id" {
  value = aws_security_group.db-sg.id
}

output "ec2-to-db-sg_id" {
  value = aws_security_group.ec2-to-db-sg.id
}

output "eks_node_sg_id" {
  value = aws_security_group.eks_node_sg.id
}

output "eks_share_sg_id" {
  value = aws_security_group.eks_shared.id
}
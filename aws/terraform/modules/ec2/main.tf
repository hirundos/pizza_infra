#bastion server
resource "aws_instance" "bastion" {
  ami                         = local.amazon_img
  instance_type               = "t2.micro"
  subnet_id                   = var.public_a_snet_id
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  key_name                    = local.my_keypair
  associate_public_ip_address = true

  tags = {
    Name = local.ec2_bastion_nm
  }
}

#eks 관리 서버
resource "aws_instance" "mgnt" {
  ami                         = local.amazon_img
  instance_type               = "t2.micro"
  subnet_id                   = var.private_a_snet_id
  vpc_security_group_ids      = [aws_security_group.mgnt-sg.id]
  key_name                    = local.my_keypair
  associate_public_ip_address = false

  root_block_device {
      volume_size = 30  
    }

  tags = {
    Name = "mgnt-instance"
  }
}

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
  vpc_security_group_ids      = [aws_security_group.mgnt-sg.id, var.eks_module_sg_id]
  key_name                    = local.my_keypair
  associate_public_ip_address = false

  user_data = <<-EOF
      #!/bin/bash
      set -e
      curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.3/2025-04-17/bin/linux/amd64/kubectl
      chmod +x kubectl
      mkdir -p /home/ec2-user/bin
      mv ./kubectl /home/ec2-user/bin/kubectl
      
      echo 'export PATH=/home/ec2-user/bin:$PATH' >> /home/ec2-user/.bash_profile
      chown -R ec2-user:ec2-user /home/ec2-user/bin

      export PATH=/home/ec2-user/bin:$PATH
    EOF

  root_block_device {
      volume_size = 30  
    }

  tags = {
    Name = "mgnt-instance"
  }
}

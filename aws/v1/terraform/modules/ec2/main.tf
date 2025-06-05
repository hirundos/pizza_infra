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

  tags = {
    Name = "mgnt-instance"
  }
}

resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg-nm"
  description = "Allow SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group" "mgnt-sg" {
  name        = "mgnt-sg-nm"
  description = "Allow SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mgnt-sg"
  }
}

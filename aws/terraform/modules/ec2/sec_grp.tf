#public에 있는 bastion
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

#eks 관리 서버
resource "aws_security_group" "mgnt-sg" {
  name        = "mgnt-sg-nm"
  description = "Allow SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
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

#db에 붙일 보안 그룹
resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "Allow EC2 to access PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2-to-db-sg.id]  # EC2 보안그룹에서만 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#db에 접근하는 ec2를 위한 보안 그룹
resource "aws_security_group" "ec2-to-db-sg" {
  name        = "ec2-to-db-sg"
  description = "Allow SSH and outbound access"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-to-db-sg"
  }
}

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
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2-to-db-sg.id] # EC2 보안그룹에서만 허용
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
    description     = "SSH access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
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

#eks에 붙일 노드그룹 sg
resource "aws_security_group" "eks_node_sg" {
  name        = "eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow control plane to communicate with worker nodes"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/16"]
  }

  ingress {
    description = "Allow worker node to worker node communication"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-node-sg"
  }
}

#eks 보안그룹
resource "aws_security_group" "eks_shared" {
  name   = "eks-shared-sg"
  vpc_id = var.vpc_id

  # 노드가 클러스터 API 서버에 접근할 수 있도록 허용
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    self      = true
  }

  # 노드 간 통신
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
    self      = true
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all egress"
  }
}

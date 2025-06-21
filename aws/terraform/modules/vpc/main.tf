resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = local.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = local.igw_name
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_subnet_a_cidr
  availability_zone       = local.az_a
  map_public_ip_on_launch = true

  tags = {
    Name = "public-snet-a"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/pizza-eks" = "shared"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_subnet_c_cidr
  availability_zone       = local.az_c
  map_public_ip_on_launch = true

  tags = {
    Name = "public-snet-c"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/pizza-eks" = "shared"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_a_cidr
  availability_zone = local.az_a

  tags = {
    Name = "private-snet-a"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_c_cidr
  availability_zone = local.az_c

  tags = {
    Name = "private-snet-c"
  }
}

#db가 위치할 subnet
resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_db_a_cidr
  availability_zone = local.az_a

  tags = {
    Name = "private-db-snet-a"
  }
}

resource "aws_subnet" "private_db_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_db_c_cidr
  availability_zone = local.az_c

  tags = {
    Name = "private-db-snet-c"
  }
}

resource "aws_db_subnet_group" "postgres" {
  name = "postgres-subnet-group"
  subnet_ids = [
    aws_subnet.private_db_a.id,
    aws_subnet.private_db_c.id
  ]

  tags = {
    Name = "PostgresSubnetGroup"
  }
}


# EIP for NAT
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags   = { Name = "pz-nat-eip" }
}

# NAT Gateway (Public A에 배치)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id
  depends_on    = [aws_internet_gateway.igw]

  tags = { Name = "pz-nat" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table (NAT)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = "private-rt" }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_a" {
  subnet_id      = aws_subnet.private_db_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_c" {
  subnet_id      = aws_subnet.private_db_c.id
  route_table_id = aws_route_table.private.id
}
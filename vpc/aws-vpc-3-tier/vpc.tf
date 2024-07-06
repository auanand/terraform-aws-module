locals {
  name_prefix = "${var.customer}-${var.product}-${var.environment}"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_subnet" "dmz_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs.dmz_a
  availability_zone = "a"
  tags = {
    Name = "${local.name_prefix}-dmz-subnet-a"
  }
}

resource "aws_subnet" "dmz_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs.dmz_b
  availability_zone = "b"
  tags = {
    Name = "${local.name_prefix}-dmz-subnet-b"
  }
}

resource "aws_subnet" "app_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs.app_a
  availability_zone = "a"
  tags = {
    Name = "${local.name_prefix}-app-subnet-a"
  }
}

resource "aws_subnet" "app_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs.app_b
  availability_zone = "b"
  tags = {
    Name = "${local.name_prefix}-app-subnet-b"
  }
}

resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs.db_a
  availability_zone = "a"
  tags = {
    Name = "${local.name_prefix}-db-subnet-a"
  }
}

resource "aws_subnet" "db_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs.db_b
  availability_zone = "b"
  tags = {
    Name = "${local.name_prefix}-db-subnet-b"
  }
}

resource "aws_route_table" "dmz" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.name_prefix}-dmz-rt"
  }
}

resource "aws_route_table_association" "dmz_a" {
  subnet_id      = aws_subnet.dmz_a.id
  route_table_id = aws_route_table.dmz.id
}

resource "aws_route_table_association" "dmz_b" {
  subnet_id      = aws_subnet.dmz_b.id
  route_table_id = aws_route_table.dmz.id
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.name_prefix}-app-rt"
  }
}

resource "aws_route_table_association" "app_a" {
  subnet_id      = aws_subnet.app_a.id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table_association" "app_b" {
  subnet_id      = aws_subnet.app_b.id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.name_prefix}-db-rt"
  }
}

resource "aws_route_table_association" "db_a" {
  subnet_id      = aws_subnet.db_a.id
  route_table_id = aws_route_table.db.id
}

resource "aws_route_table_association" "db_b" {
  subnet_id      = aws_subnet.db_b.id
  route_table_id = aws_route_table.db.id
}

resource "aws_network_acl" "dmz" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.name_prefix}-dmz-nacl"
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_network_acl_association" "dmz_a" {
  subnet_id      = aws_subnet.dmz_a.id
  network_acl_id = aws_network_acl.dmz.id
}

resource "aws_network_acl_association" "dmz_b" {
  subnet_id      = aws_subnet.dmz_b.id
  network_acl_id = aws_network_acl.dmz.id
}

resource "aws_network_acl" "app" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.name_prefix}-app-nacl"
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_network_acl_association" "app_a" {
  subnet_id      = aws_subnet.app_a.id
  network_acl_id = aws_network_acl.app.id
}

resource "aws_network_acl_association" "app_b" {
  subnet_id      = aws_subnet.app_b.id
  network_acl_id = aws_network_acl.app.id
}

resource "aws_network_acl" "db" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.name_prefix}-db-nacl"
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_network_acl_association" "db_a" {
  subnet_id      = aws_subnet.db_a.id
  network_acl_id = aws_network_acl.db.id
}

resource "aws_network_acl_association" "db_b" {
  subnet_id      = aws_subnet.db_b.id
  network_acl_id = aws_network_acl.db.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

resource "aws_route" "dmz_route" {
  route_table_id         = aws_route_table.dmz.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.dmz_a.id
  tags = {
    Name = "${local.name_prefix}-nat"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "app_nat_route" {
  route_table_id         = aws_route_table.app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
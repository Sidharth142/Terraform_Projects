resource "aws_vpc" "sidhu-vpc" {
  cidr_block       = "55.0.0.0/20"
  instance_tenancy = "default"

  tags = {
    Name = "sidhu-vpc"
  }
}

resource "aws_subnet" "web1" {
  vpc_id     = aws_vpc.sidhu-vpc.id
  cidr_block = "55.0.1.0/24"
  map_public_ip_on_launch=true

  tags = {
    Name = "web1"
  }
}

resource "aws_subnet" "db" {
  vpc_id     = aws_vpc.sidhu-vpc.id
  cidr_block = "55.0.2.0/23"
  map_public_ip_on_launch=false

  tags = {
    Name = "db"
  }
}

resource "aws_internet_gateway" "sidhu-igw" {
  vpc_id = aws_vpc.sidhu-vpc.id

  tags = {
    Name = "sidhu-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.sidhu-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sidhu-igw.id
  }

  tags = {
    Name = "rt"
  }
}

resource "aws_route_table_association" "web1" {
  subnet_id      = aws_subnet.web1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "db" {
  subnet_id      = aws_subnet.db.id
  route_table_id = aws_route_table.rt.id
}





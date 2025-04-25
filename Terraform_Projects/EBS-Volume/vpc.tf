resource "aws_vpc" "main" {
  cidr_block = "55.0.0.0/20"
  tags = {
    name = "main"
  }
}

resource"aws_subnet" "public" {
  vpc_id =aws_vpc.main.id
  cidr_block = "55.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    name = "public"
  }
}

resource"aws_subnet" "private" {
  vpc_id =aws_vpc.main.id
  cidr_block = "55.0.2.0/23"
  map_public_ip_on_launch = "false"
  tags = {
    name = "private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt"{
  vpc_id = aws_vpc.main.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.rt.id
}

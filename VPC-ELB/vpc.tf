# vpc
resource "aws_vpc" "jette_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "jette_vpc1"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "jette_igw" {
  vpc_id = aws_vpc.jette_vpc.id
  tags = {
    Name = "main"
  }
}

#subnet:public
resource "aws_subnet" "jette_web1" {
  count = length(var.subnets_cidr)
  vpc_id = aws_vpc.jette_vpc.id
  cidr_block = element(var.subnets_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet-${count.index+1}"
  }
}

# Route table: attach Internet Gateway
resource "aws_route_table" "jette_IGW_RT" {
  vpc_id = aws_vpc.jette_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jette_igw.id
  }
  tags = {
    Name = var.rt
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "a" {
  count = length(var.subnets_cidr)
  subnet_id      = element(aws_subnet.jette_web1.*.id,count.index)
  route_table_id = aws_route_table.jette_IGW_RT.id
}

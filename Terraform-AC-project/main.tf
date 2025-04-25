# Creating a VPC (Virtual Private Cloud) - It's like your own private network in AWS
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr # For example: 10.0.0.0/16
}

# Creating a subnet (small network inside VPC) in zone us-west-2a and allowing public IP
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true # So that instances get a public IP automatically
}

# Another subnet in a different zone (us-west-2b) for high availability
resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
}

# Creating an Internet Gateway to give internet access to resources inside VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

# Creating a route table to define how traffic should flow (in this case, to the internet)
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0" # This means all internet traffic
    gateway_id = aws_internet_gateway.igw.id # Use Internet Gateway for outgoing traffic
  }
}

# Linking the subnet1 to the route table, so it can access the internet
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

# Linking subnet2 to the same route table to allow internet access
resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
}

# Creating a Security Group (acts like a firewall) to allow specific traffic
resource "aws_security_group" "websg" {
  name        = "websg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  # Allow incoming web traffic on port 80 (HTTP)
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from anywhere
  }

  # Allow incoming SSH access on port 22 (for connecting to the server)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from anywhere
  }

  # Allow all outgoing traffic (default setting)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # -1 means all protocols
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "websg"
  }
}

# Creating an S3 bucket (storage service to store files, logs, backups, etc.)
resource "aws_s3_bucket" "example" {
  bucket = "sidhu2025-terraform-project"
}

# Launching the first EC2 instance (virtual server) in subnet1
resource "aws_instance" "webserver1" {
  ami                    = "ami-075686beab831bb7f" # OS image to use for the server
  instance_type          = "t2.micro" # Small free-tier instance
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data              = base64encode(file("userdata.sh")) # Script to run on boot
}

# Launching the second EC2 instance in the same subnet
resource "aws_instance" "webserver2" {
  ami                    = "ami-075686beab831bb7f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data              = base64encode(file("userdata1.sh"))
}

# Creating an Application Load Balancer to distribute incoming traffic across servers
resource "aws_lb" "myalb" {
  name               = "myalb"
  internal           = false # false means it’s public-facing (accessible from the internet)
  load_balancer_type = "application"

  security_groups = [aws_security_group.websg.id]
  subnets         = [aws_subnet.sub1.id, aws_subnet.sub2.id] # Place load balancer in both subnets

  tags = {
    Name = "web"
  }
}

# Creating a Target Group (group of instances behind the load balancer)
resource "aws_lb_target_group" "tg" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = "/" # Check if the app is healthy at root URL
    port = "traffic-port" # Check on the port that the app is using
  }
}

# Attaching webserver1 to the target group
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

# Attaching webserver2 to the target group
resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

# Creating a Listener to listen for incoming HTTP requests and forward them to the target group
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward" # Forward incoming traffic to the target group
  }
}

# Output the DNS name of the load balancer, so you can access your application
output "loadbalancerdns" {
  value = aws_lb.myalb.dns_name
}

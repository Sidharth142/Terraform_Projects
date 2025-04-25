resource "aws_instance" "sidhu"{
  ami = var.ami
  availability_zone = var.availability_zone
  instance_type = var.instance
  key_name = var.key_name
  security_groups = [var.security_groups]

  tags = {
    Name = "web"
    Env = "db"
  }
}
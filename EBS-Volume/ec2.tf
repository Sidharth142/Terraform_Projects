resource "aws_instance" "jette-instance" {
  availability_zone = "us-west-2a"
  #count = 2
  ami = "ami-03732836c84e7c86e"
  instance_type = "t2.micro"
  key_name = "isaipauyal"
  security_groups = ["EBS_SG"]

  tags = {
    Name = var.tag_name
    Env = "db"
    user = "sidhu"
  }
}

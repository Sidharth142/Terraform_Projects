resource "aws_instance" "new_ec2" {
  ami                                  = "ami-0eb9d67c52f5c80e5"
  instance_type                        = "t2.micro"
  key_name                             = "isaipauyal"

  tags                                 = {
    "Name" = "web123"
  }

}
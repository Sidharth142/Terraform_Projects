data "aws_ami" "instance" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = var.value
  }
}

resource "aws_instance" "HelloWorld" {
  ami           = data.aws_ami.instance.id
  instance_type = var.machinetype
  key_name      = "isaipauyal"

  tags = {
    Name = "sidhu"
  }
}



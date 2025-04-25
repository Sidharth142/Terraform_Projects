resource "aws_instance" "webserver" {
  ami = var.amiid
  instance_type = var.machinetype
  security_groups = [var.sgname]
  key_name = var.keyname

  tags = {
    Name = var.mytag
  }

}
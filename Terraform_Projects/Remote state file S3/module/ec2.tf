resource "aws_instance" "webserver" {
  ami           = var.amiid
  instance_type = var.machinetype
  key_name      = var.keyname

  tags = {
    Name = var.mytag
  }
}
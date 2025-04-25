resource "aws_ebs_volume" "ebs-volume" {
  availability_zone = "us-west-2a"
  size=1
  type="gp2"

  tags = {
    Name = "extra volume "
  }
}

resource "aws_volume_attachment" "ebs-volume-attachment" {
  device_name = "/dev/xvdh"
  volume_id = aws_ebs_volume.ebs-volume.id
  instance_id = aws_instance.jette-instance.id
}
resource "aws_elb" "web-lb" {

  availability_zones          = [
    "us-west-2a",
    "us-west-2b",
  ]
  connection_draining         = true
  connection_draining_timeout = 300
  cross_zone_load_balancing   = true
  desync_mitigation_mode      = "defensive"


  idle_timeout                = 60
  instances                   = [
    "i-05eefe4b55e56cb62",
  ]
  internal                    = false
  name                        = "web-lb"
  security_groups             = [
    "sg-0a1b323d964e07b71",
  ]
  source_security_group       = "244278891905/EBS_SG"

  subnets                     = [
    "subnet-0710fb41e8fcf3b6e",
    "subnet-0960dad1df0853ca9",
  ]
  tags                        = {
    Name = "new-123"
  }
  tags_all                    = {}


  health_check {
    healthy_threshold   = 10
    interval            = 5
    target              = "HTTP:80/index.html"
    timeout             = 2
    unhealthy_threshold = 2
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
    ssl_certificate_id = null
  }
}

variable "ami"{
  default = "ami-03732836c84e7c86e"
}

variable "availability_zone"{
  default = "us-west-2a"
}

variable "instance"{
  default = "t2.micro"
}

variable "key_name"{
  default="isaipauyal"
}

variable "security_groups"{
  default = "EBS_SG"
}

variable "tag_name"{
  default = "prod"
}


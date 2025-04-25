variable "aws_region"{
  default = "us-west-2"
}

variable "vpc_cidr"{
  default = "55.0.0.0/20"
}

variable "subnets_cidr"{
  type = list(any)
  default = ["55.0.1.0/24","55.0.4.0/24"]
}

variable "azs"{
  type = list(any)
  default = ["us-west-2a", "us-west-2b"]
}

variable "webservers_ami"{
  default = "ami-03732836c84e7c86e"
}

variable "instance_type"{
  default = "t2.micro"
}

variable "rt"{
  default = "publicRouteTable"
}
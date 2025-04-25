# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "4.9.0"
#     }
#   }
# }
#
# provider "aws" {
#   region = "us-west-2"
# }


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # for major version 5 and later patches

    }
  }
}

provider "aws" {
  region = "us-west-2"
}
# Configuration option
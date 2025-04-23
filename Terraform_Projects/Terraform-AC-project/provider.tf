terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"  # for major version 5 and later patches

    }
  }
}

provider "aws" {
  region = "us-west-2"
}

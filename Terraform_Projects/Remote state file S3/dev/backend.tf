terraform {
  backend "s3" {
    bucket         = "ausfallen"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "test"

  }
}
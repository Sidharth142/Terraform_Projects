#creating s3 bucket
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.bucketname
  #acl    = "private"

  tags = {
    Name        = "s3bucket"
    Environment = "dev"
  }
}

# s3 bucket ownership control
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.s3bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# s3 bucket for public access
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.s3bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ACL permission
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.s3bucket.id
  acl    = "public-read"
}

# object definition for index.html
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.s3bucket.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

# object definition for error.html
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.s3bucket.id
  key = "error.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

# object definition for profile pic
#resource "aws_s3_object" "profile" {
  #bucket = aws_s3_bucket.s3bucket.id
  #key = "profile.png"
  #source = "profile.png"
  #acl = "public-read"
#}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.s3bucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.example]
}



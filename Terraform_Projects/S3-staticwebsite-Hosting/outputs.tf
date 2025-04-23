output "websiteendpoint" {
  value = aws_s3_bucket.s3bucket.website_endpoint
}

output "bucketname" {
  value = aws_s3_bucket.s3bucket.bucket
}
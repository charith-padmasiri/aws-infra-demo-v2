variable "AWS_SECRET_ACCESS_KEY" {
  default = "nAH2VzKrMrRjySLlt8HCdFU3tM2TUuUZgh39NX"
}


# Example 1: Public read access (existing)
resource "aws_s3_bucket" "a_very_bad_public_s3_bucket" {
  bucket = "my-public-bucket-3"
  acl    = "private"
}


# Example 2: Public write access - SECURITY ISSUE
resource "aws_s3_bucket" "dangerous_public_write_bucket" {
  bucket = "my-dangerous-write-bucket"
  acl    = "public-read"
}
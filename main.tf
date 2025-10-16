variable "AWS_SECRET_ACCESS_KEY" {
  default = "nAH2VzKrMrRjySLlt8HCdFU3tM2TUuUZgh39NX"
}

# Example 1: Public read access (existing)
resource "aws_s3_bucket" "a_very_bad_public_s3_bucket" {
  bucket = "my-public-bucket-3"
  acl    = "public-read"
}

# Example 2: Public write access - SECURITY ISSUE
# Proposed fix: Remove the bucket policy or restrict Principal to specific accounts
resource "aws_s3_bucket" "dangerous_public_write_bucket" {
  bucket = "my-dangerous-write-bucket"
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "dangerous_public_write_policy" {
  bucket = aws_s3_bucket.dangerous_public_write_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPublicWrite"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.dangerous_public_write_bucket.arn}/*"
      }
    ]
  })
}
variable "AWS_SECRET_ACCESS_KEY" {
  default = "nAH2VzKrMrRjySLlt8HCdFU3tM2TUuUZgh39NX"
}

resource "aws_s3_bucket" "a_very_bad_public_s3_bucket" {
  bucket = "my-public-bucket-3"
  acl    = "private"
}

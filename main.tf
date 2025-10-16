variable "AWS_SECRET_ACCESS_KEY" {
  default = "nAH2VzKrMrRjySLlt8HCdFU3tM2TUuUZgh39NX"
}

# Example 1: Public read access (existing)
resource "aws_s3_bucket" "a_very_bad_public_s3_bucket" {
  bucket = "my-public-bucket-3"
  acl    = "public-read"
}

# Example 2: Public write access - SECURITY ISSUE
# Proposed fix: Change acl to "private" or "public-read"
resource "aws_s3_bucket" "dangerous_public_write_bucket" {
  bucket = "my-dangerous-write-bucket"
  acl    = "public-read-write"
}

# Example 3: Bucket with no encryption - SECURITY ISSUE
# Proposed fix: Add server_side_encryption_configuration
resource "aws_s3_bucket" "unencrypted_sensitive_bucket" {
  bucket = "my-unencrypted-bucket"
  acl    = "private"
}

# Example 4: Bucket with overly permissive bucket policy - SECURITY ISSUE
# Proposed fix: Restrict the Principal to specific AWS accounts/users
resource "aws_s3_bucket" "overly_permissive_bucket" {
  bucket = "my-permissive-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "overly_permissive_policy" {
  bucket = aws_s3_bucket.overly_permissive_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowAllActions"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.overly_permissive_bucket.arn,
          "${aws_s3_bucket.overly_permissive_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Example 5: Bucket with versioning disabled and no lifecycle rules - SECURITY ISSUE
# Proposed fix: Enable versioning and add lifecycle rules for data retention
resource "aws_s3_bucket" "no_versioning_bucket" {
  bucket = "my-no-versioning-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "no_versioning" {
  bucket = aws_s3_bucket.no_versioning_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

# Example 6: Bucket with no access logging - SECURITY ISSUE
# Proposed fix: Enable access logging for audit trails
resource "aws_s3_bucket" "no_logging_bucket" {
  bucket = "my-no-logging-bucket"
  acl    = "private"
}

# Example 7: Bucket with no MFA delete protection - SECURITY ISSUE
# Proposed fix: Enable MFA delete for additional security
resource "aws_s3_bucket" "no_mfa_protection_bucket" {
  bucket = "my-no-mfa-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "no_mfa_versioning" {
  bucket = aws_s3_bucket.no_mfa_protection_bucket.id
  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
}

# Example 8: Bucket with CORS allowing all origins - SECURITY ISSUE
# Proposed fix: Restrict AllowedOrigins to specific domains
resource "aws_s3_bucket" "cors_wildcard_bucket" {
  bucket = "my-cors-wildcard-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_cors_configuration" "cors_wildcard" {
  bucket = aws_s3_bucket.cors_wildcard_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# Example 9: Bucket with no block public access settings - SECURITY ISSUE
# Proposed fix: Enable all block public access settings
resource "aws_s3_bucket" "no_block_public_access_bucket" {
  bucket = "my-no-block-public-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "no_block_public_access" {
  bucket = aws_s3_bucket.no_block_public_access_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Example 10: Bucket with weak encryption algorithm - SECURITY ISSUE
# Proposed fix: Use AES256 or aws:kms instead of aws:kms with weak key
resource "aws_s3_bucket" "weak_encryption_bucket" {
  bucket = "my-weak-encryption-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "weak_encryption" {
  bucket = aws_s3_bucket.weak_encryption_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = false
  }
}

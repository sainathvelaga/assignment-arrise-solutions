
resource "aws_s3_bucket" "task_bucket" {
  provider = aws.account_b

  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "task_bucket" {
  provider = aws.account_b

  bucket = aws_s3_bucket.task_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role_policy" "roleC_s3_policy" {
  provider = aws.account_b

  name = "roleC-specific-bucket-access"
  role = aws_iam_role.roleC.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = "s3:*"

        Resource = [
          aws_s3_bucket.task_bucket.arn,
          "${aws_s3_bucket.task_bucket.arn}/*"
        ]
      }
    ]
  })
}


# Trust policy for roleC in Account B
data "aws_iam_policy_document" "roleC_trust" {
  provider = aws.account_b

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"

      # Trust the exact roleB ARN from Account A
      identifiers = [
        aws_iam_role.roleB.arn
      ]
    }
  }
}

# RoleC in Account B
resource "aws_iam_role" "roleC" {
  provider = aws.account_b

  name               = "roleC"
  assume_role_policy = data.aws_iam_policy_document.roleC_trust.json
}

# Restrict roleC to the designated S3 bucket
resource "aws_iam_role_policy" "roleC_s3" {
  provider = aws.account_b

  name = "roleC-s3-access"
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

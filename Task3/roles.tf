
# Trust policy for roles in Account A
data "aws_iam_policy_document" "account_a_trust" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.account_a_id}:root"
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

# -------------------------------------
# ROLE A - Account A
# Admin access except IAM
# -------------------------------------

resource "aws_iam_role" "roleA" {
  name               = "roleA"
  assume_role_policy = data.aws_iam_policy_document.account_a_trust.json
}

resource "aws_iam_role_policy" "roleA_policy" {
  name = "roleA-admin-except-iam"
  role = aws_iam_role.roleA.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      },
      {
        Effect   = "Deny"
        Action   = "iam:*"
        Resource = "*"
      }
    ]
  })
}

# -------------------------------------
# ROLE B - Account A
# Can assume only Account B roleC
# -------------------------------------

resource "aws_iam_role" "roleB" {
  name               = "roleB"
  assume_role_policy = data.aws_iam_policy_document.account_a_trust.json
}

resource "aws_iam_role_policy" "roleB_policy" {
  name = "assume-roleC-only"
  role = aws_iam_role.roleB.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = "sts:AssumeRole"

        Resource = "arn:aws:iam::${var.account_b_id}:role/roleC"
      }
    ]
  })
}

# -------------------------------------
# ROLE C - Account B
# Trusts only Account A roleB
# -------------------------------------

resource "aws_iam_role" "roleC" {
  provider = aws.account_b

  name = "roleC"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          AWS = aws_iam_role.roleB.arn
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

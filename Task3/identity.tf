
data "aws_caller_identity" "account_a" {}

data "aws_caller_identity" "account_b" {
  provider = aws.account_b
}

output "account_a_identity" {
  value = data.aws_caller_identity.account_a.arn
}

output "account_b_identity" {
  value = data.aws_caller_identity.account_b.arn
}

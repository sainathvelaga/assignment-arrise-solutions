
output "role_arns" {
  value = {
    roleA = aws_iam_role.roleA.arn
    roleB = aws_iam_role.roleB.arn
    roleC = aws_iam_role.roleC.arn
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.task_bucket.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.task_bucket.arn
}

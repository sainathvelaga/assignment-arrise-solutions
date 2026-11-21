output "state_bucket" {
  description = "Pass to: terraform init -backend-config=\"bucket=<this>\""
  value       = aws_s3_bucket.tfstate.bucket
}

output "dynamodb_table" {
  description = "Pass to: terraform init -backend-config=\"dynamodb_table=<this>\""
  value       = aws_dynamodb_table.terraform_locks.name
}
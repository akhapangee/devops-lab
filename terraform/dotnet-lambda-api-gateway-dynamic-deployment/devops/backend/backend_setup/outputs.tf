output "s3_bucket_name" {
  description = "The name of the S3 bucket created for Terraform state."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table created for state locks."
  value       = aws_dynamodb_table.terraform_locks.name
}

# ------------------------------------------
# Define Variables
# ------------------------------------------

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for storing Terraform state"
  type        = string
  default     = "devops-lab-terraform-tfstate"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "devops-lab-terraform-locks"
}
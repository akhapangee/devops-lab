terraform {
  backend "s3" {
    bucket               = "devops-lab"
    key                  = "backend/terraform.tfstate"
    region               = "us-east-1"
    encrypt              = true
    dynamodb_table       = "terraform-locks"
    workspace_key_prefix = "terraform"
  }
}
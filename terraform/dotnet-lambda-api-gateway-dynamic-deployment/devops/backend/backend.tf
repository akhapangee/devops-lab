terraform {
  backend "s3" {
    bucket               = "devops-lab-terraform-tfstate"
    key                  = "backend/terraform.tfstate"
    region               = "us-east-1"
    encrypt              = true
    dynamodb_table       = "devops-lab-terraform-locks"
    workspace_key_prefix = "terraform"
  }
}
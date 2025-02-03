#!/bin/bash

# Validate input
ENV=$1
if [[ "$ENV" != "dev" && "$ENV" != "prod" ]]; then
  echo "Usage: $0 [dev|prod]"
  exit 1
fi

# Initialize Terraform
terraform init

# Select or create workspace
terraform workspace select $ENV || terraform workspace new $ENV

# Run Terraform Plan
echo "Running Terraform Plan for $ENV..."
terraform plan -var-file="${ENV}.tfvars" -out=tfplan

# Prompt user for confirmation before applying
read -p "Do you want to apply the changes? (yes/no): " CONFIRM
if [[ "$CONFIRM" == "yes" ]]; then
  echo "Applying Terraform changes..."
  terraform apply tfplan
else
  echo "Terraform apply canceled."
fi

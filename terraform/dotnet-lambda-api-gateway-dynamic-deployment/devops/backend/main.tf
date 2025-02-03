provider "aws" {
  region = var.aws_region
}

# ------------------------------------------
# IAM Role for Lambda
# ------------------------------------------
module "iam" {
  source    = "../modules/iam"
  role_name = "TSGRECR_lambda_role_${terraform.workspace}"
}

# ------------------------------------------
# API Gateway
# ------------------------------------------
resource "aws_api_gateway_rest_api" "api" {
  name        = "test-api-name"
  description = "API Description"
  tags        = var.tags
}

module "lambda" {
  source          = "../modules/lambda"
  lambdas         = var.lambdas
  lambda_role_arn = module.iam.role_arn
}

module "api_gateway" {
  source                     = "../modules/api_gateway"
  lambdas                    = var.lambdas
  api_gateway                = aws_api_gateway_rest_api.api
  aws_region                 = var.aws_region
  stage_name                 = "dev"
  lambda_function_references = module.lambda.lambda_function_references
  tags                       = var.tags
}

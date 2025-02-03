variable "lambdas" {
  description = "List of Lambda configurations"
  type        = list(object({
    function_name = string
    handler       = string
    runtime       = string
    source_path   = string
    resource_path = string
    http_method   = string
    memory_size   = number
    timeout       = number
  }))
}

variable "api_gateway" {
  description = "Reference to the API Gateway resource"
  type        = any
}

variable "lambda_function_references" {
  description = "Map of Lambda function resource references by function name"
  type        = map(object({
    lambda_reference = any  # Can store any Lambda resource type or reference
  }))
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
}

variable "stage_name" {
  description = "Stage Name"
  type        = string
}


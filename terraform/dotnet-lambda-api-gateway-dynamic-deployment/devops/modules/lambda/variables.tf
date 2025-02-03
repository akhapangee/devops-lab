variable "lambdas" {
  description = "List of Lambda configurations"
  type = list(object({
    function_name  = string
    handler        = string
    runtime        = string
    source_path    = string
    resource_path  = string
    http_method    = string
    memory_size    = number
    timeout        = number
  }))
}

variable "lambda_role_arn" {
  description = "IAM role ARN for Lambda"
  type        = string
}

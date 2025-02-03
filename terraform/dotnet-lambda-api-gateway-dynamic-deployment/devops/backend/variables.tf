variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
}

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

variable "s3_bucket_name" {
  default = "devops-lab"
}

variable "dynamodb_table_name" {
  default = "terraform-locks"
}


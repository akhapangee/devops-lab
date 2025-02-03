resource "aws_lambda_function" "lambda_functions" {
  for_each = {for lambda in var.lambdas : lambda.function_name => lambda}

  function_name = each.value.function_name
  handler       = each.value.handler
  runtime       = each.value.runtime
  filename      = each.value.source_path
  memory_size   = each.value.memory_size
  timeout       = each.value.timeout
  role          = var.lambda_role_arn
  source_code_hash = filebase64sha256(each.value.source_path)
}


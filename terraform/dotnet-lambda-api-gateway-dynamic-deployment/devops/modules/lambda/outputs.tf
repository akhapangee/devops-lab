output "lambda_function_references" {
  value = {
    for lambda in aws_lambda_function.lambda_functions :
    lambda.function_name => {
      lambda_reference = lambda  # Include the resource reference
    }
  }
}
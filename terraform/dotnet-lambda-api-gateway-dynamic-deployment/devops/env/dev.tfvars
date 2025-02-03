aws_region = "us-east-1"
tags = {
  Environment = "Dev"
  Project     = "Devops Lab"
}

lambdas = [
  {
    function_name  = "Login_dev"
    handler        = "Login::Login.Handlers.LoginHandler::LogIn"
    runtime        = "dotnet8"
    source_path    = "../../backend/artifacts/Login.zip"
    resource_path  = "login"
    http_method    = "POST"
    memory_size    = 128
    timeout        = 10
  }
]


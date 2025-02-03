aws_region = "us-east-1"
tags = {
  Environment = "Prod"
  Project     = "Devops Lab Prod"
}

lambdas = [
  {
    function_name  = "Login_Prod"
    handler        = "Login::Login.Handlers.LoginHandler::LogIn"
    runtime        = "dotnet8"
    source_path    = "../../backend/artifacts/Login.zip"
    resource_path  = "login"
    http_method    = "POST"
    memory_size    = 128
    timeout        = 10
  }
]


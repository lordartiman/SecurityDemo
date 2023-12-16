provider "aws" {
  region = "us-east-1"  # Replace with your AWS region
}

resource "aws_dynamodb_table" "login_data" {
  name           = "LoginData"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Username"

  attribute {
    name = "Username"
    type = "S"
  }
}

# module "repository" {
#   for_each = local.repos

#   source  = "ALT-F4-LLC/repository/github"
#   version = "0.8.0"

#   description        = each.value.description
#   gitignore_template = each.value.gitignore_template
#   name               = each.value.name
#   owner              = var.owner
#   topics             = each.value.topics
#   visibility         = each.value.visibility
# }

provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  # skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false
}


module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "sqs-payload-logger"
  description   = "AWS lambda Function"
  handler       = "sqs-payload-logger.sqsPayloadLoggerHandler"
  runtime       = "python3.12"

  source_path = "src/handler"

  tags = {
    Name = "my-lambda1"
  }
}
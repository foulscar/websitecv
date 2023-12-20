// ---
// Create Lambda Function to Push Metrics to DynamoDB
// ---

resource "aws_lambda_function" "lambda_tf_websitecv_putmetrics" {
  filename         = "lambda/tf_websitecv_putmetrics.zip"
  function_name    = "${var.stage}_tf_websitecv_putmetrics"
  role             = module.iam_tf_websitecv_putmetrics.role_arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda/tf_websitecv_putmetrics.zip")
  runtime          = "python3.11"
  timeout          = 10

  environment {
    variables = {
      CLOUDFRONT_ID            = module.cloudfront_distribution.id
      API_GATEWAY_PUBLIC_NAME  = module.public_api.api_name
      API_GATEWAY_PRIVATE_NAME = module.private_api.api_name
      API_GATEWAY_PRIVATE_ID   = module.private_api.api_id
      DYNAMODB_TABLE_NAME      = module.dynamodb_table.table_name
    }
  }
}

// ---
// Create Lambda Function to Get Metrics from DynamoDB
// ---

resource "aws_lambda_function" "lambda_tf_websitecv_getmetrics" {
  filename         = "lambda/tf_websitecv_getmetrics.zip"
  function_name    = "${var.stage}_tf_websitecv_getmetrics"
  role             = module.iam_tf_websitecv_getmetrics.role_arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda/tf_websitecv_getmetrics.zip")
  runtime          = "python3.11"
  timeout          = 5

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = module.dynamodb_table.table_name
    }
  }
}

// ---
// Create Lambda Function to make API Calls to the Private Rest API
// ---

resource "aws_lambda_function" "lambda_tf_proxy_websitecv_getmetrics" {
  filename         = "lambda/tf_proxy_websitecv_getmetrics.zip"
  function_name    = "${var.stage}_tf_proxy_websitecv_getmetrics"
  role             = module.iam_tf_proxy_websitecv_getmetrics.role_arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda/tf_proxy_websitecv_getmetrics.zip")
  runtime          = "python3.11"
  timeout          = 5

  vpc_config {
    subnet_ids         = module.private_vpc.subnet_ids
    security_group_ids = [aws_security_group.private_sg.id]
  }

  environment {
    variables = {
      VPC_ENDPOINT_DNS = "${module.private_api.api_id}.execute-api.${data.aws_region.current.name}.amazonaws.com"
    }
  }
}

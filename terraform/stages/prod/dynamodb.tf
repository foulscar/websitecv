// ---
// Create the DynamoDB Table Used for Storing Metrics
// ---

module "dynamodb_table" {
  source = "../../modules/aws/dynamodb/pay_per_request/v1"

  table_name = "${var.stage}-websitecv-table"
  hash_key   = "ID"
}

// ---
// Init Data in DynamoDB using the tf_putmetrics lambda function
// ---

data "aws_lambda_invocation" "init_dynamodb_items" {
  function_name = aws_lambda_function.lambda_tf_websitecv_putmetrics.function_name

  input = ""
}

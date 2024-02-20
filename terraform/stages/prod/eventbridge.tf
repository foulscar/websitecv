// ---
// Create EventBridge rule to push metrics to DynamoDB every hour
// ---

module "eventbridge_rule_push_metrics_dynamodb" {
  source = "../../modules/aws/eventbridge/simple_invoke_rule/v1"

  name                = "${var.stage}-push-metrics-dynamodb"
  description         = "Invokes tf_websitecv_putmetrics every hour"
  schedule_expression = "rate(1 hour)"
  lambda_arn          = aws_lambda_function.lambda_tf_websitecv_putmetrics.arn
}

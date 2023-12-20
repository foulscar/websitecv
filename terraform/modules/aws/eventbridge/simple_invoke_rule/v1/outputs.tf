output "rule_arn" {
    description = "ARN of the EventBridge Rule"
    value = aws_cloudwatch_event_rule.rule.arn
}
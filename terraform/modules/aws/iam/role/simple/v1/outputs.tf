output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.role.arn
}

output "policy_arns" {
  description = "The ARNs of the created IAM policies"
  value       = { for k, v in aws_iam_policy.policy : k => v.arn }
}

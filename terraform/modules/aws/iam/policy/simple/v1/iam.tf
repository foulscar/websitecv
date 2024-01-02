// ---
// Create IAM Policy and Attach it to the Role
// ---

resource "aws_iam_policy" "policy" {
  name   = var.name
  policy = templatefile(var.policy_file, var.attributes)
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = var.role_name
  policy_arn = aws_iam_policy.policy.arn
}

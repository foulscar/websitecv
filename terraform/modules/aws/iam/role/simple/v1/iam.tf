resource "aws_iam_role" "role" {
  name = var.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = var.service
        }
      }
    ]
  })
}

resource "aws_iam_policy" "policy" {
  for_each = var.policies

  name   = each.value.name
  policy = templatefile(each.value.policy_file, each.value.attributes)
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  for_each   = aws_iam_policy.policy

  role       = aws_iam_role.role.name
  policy_arn = each.value.arn
}

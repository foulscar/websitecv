{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:sts::053160724612:assumed-role/aws-assume-role-ProviderFunctionRole-*/aws-assume-role-ProviderFunction-*"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${repo}"
        }
      }
    }
  ]
}

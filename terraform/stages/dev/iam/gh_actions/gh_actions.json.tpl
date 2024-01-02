{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "AllowS3BucketManipulation",
			"Effect": "Allow",
			"Action": [
				"s3:PutObject",
				"s3:GetObject",
				"s3:DeleteObject",
				"s3:ListMultipartUploadParts",
				"s3:AbortMultipartUpload",
				"s3:ListBucket"
			],
			"Resource": "${bucket_arn}/*"
		},
		{
			"Sid": "AllowS3BucketListing",
			"Effect": "Allow",
			"Action": [
				"s3:ListBucket"
			],
			"Resource": "${bucket_arn}"
		},
		{
			"Sid": "CFInvalidation",
			"Effect": "Allow",
			"Action": "cloudfront:CreateInvalidation",
			"Resource": "${distribution_arn}"
		}
	]
}

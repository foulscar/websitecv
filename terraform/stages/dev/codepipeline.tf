// ---
// Create the CodePipeline to deploy files from CodeCommit to S3
// ---

module "codepipeline_codecommit_to_s3" {
  source = "../../modules/aws/codepipeline/simple_s3/v1"

  name = "${var.stage}-websitecv-codecommit-to-s3-pipeline"
  role_arn = module.iam_codepipeline.role_arn
  artifact_bucket_name = module.s3_bucket_artifacts.s3_bucket_id
  codecommit_branch = aws_codecommit_repository.websitecv_html_repo.default_branch
  codecommit_repo = aws_codecommit_repository.websitecv_html_repo.repository_name
  deploy_bucket_name = module.s3_bucket.s3_bucket_id
}

// ---
// Create the Pipeline to transfer files from CodeCommit to S3
// ---

resource "aws_codepipeline" "codepipeline" {
  name = var.name
  role_arn = var.role_arn
  
  artifact_store {
    location = var.artifact_bucket_name
    type = "S3"
  }

  stage {
    name = "source"

    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "CodeCommit"
      version = "1"
      output_artifacts = [ "SourceArtifact" ]

      configuration = {
        RepositoryName = var.codecommit_repo
        BranchName = var.codecommit_branch
      }
    }
  }

  stage {
    name = "deploy"

    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "S3"
      version = "1"
      input_artifacts = [ "SourceArtifact" ]

      configuration = {
        BucketName = var.deploy_bucket_name
        Extract = "true"
      }
    }
  }
}

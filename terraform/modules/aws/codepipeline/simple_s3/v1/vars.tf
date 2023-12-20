variable "name" {
  description = "Name of the Pipeline"
  type = string
}

variable "role_arn" {
  description = "ARN of the Service Role to use for CodePipeline"
  type = string
}

variable "artifact_bucket_name" {
  description = "Bucket Name to store artifacts in"
  type = string
}

variable "codecommit_branch" {
  description = "CodeCommit Branch to use as source"
  type = string
}

variable "codecommit_repo" {
  description = "CodeCommit Repo to use as source"
  type = string
}

variable "deploy_bucket_name" {
  description = "Bucket Name to deploy to"
  type = string
}

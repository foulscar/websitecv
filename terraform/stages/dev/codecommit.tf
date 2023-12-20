// ---
// Get the name of the Current AWS User
// ---

resource "null_resource" "get_aws_user_name" {
  provisioner "local-exec" {
    command = "aws iam get-user --query 'User.UserName' --output text >> ${path.module}/temp/.current_aws_user_name.txt"
  }
}

data "local_file" "current_aws_user_name" {
  filename = "${path.module}/temp/.current_aws_user_name.txt"
  depends_on = [ null_resource.get_aws_user_name ]
}

// ---
// Create the CodeCommit Repo for hosting the web files
// ---

resource "aws_codecommit_repository" "websitecv_html_repo" {
  repository_name = "${var.stage}-websitecv-html-repo"
  default_branch = "master"
  description = "repo for pushing web files to S3"
}

// ---
// Create CodeCommit Credentials
// ---

resource "aws_iam_service_specific_credential" "codecommit_creds" {
  service_name = "codecommit.amazonaws.com"
  user_name = trimspace(data.local_file.current_aws_user_name.content)
}

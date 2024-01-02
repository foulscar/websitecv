variable "stage" {
  description = "Stage/Environment in use"
  type = string
}

variable "domain_name" {
  description = "Root Domain Name to Use"
  type = string
}

variable "gh_repo_name" {
  description = "Name of the GitHub Repo to Use"
  type = string
}

variable "gh_repo_owner" {
  description = "Owner of the GitHub Repo"
  type = string
}

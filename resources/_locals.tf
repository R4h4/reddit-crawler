# Technically not a local, but only relevant for the access tokens below
data "aws_secretsmanager_secret_version" "github_access" {
  secret_id = "GitHub/CodeDeploy"
}


locals {
  default_tags = {
    terraform = "true"
    project = var.app_name,
    service = "main"
    environment = var.app_environment
  }

  github_tokens = jsondecode(
    data.aws_secretsmanager_secret_version.github_access.secret_string
  )
}
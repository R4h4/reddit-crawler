locals {
  stage = "prod"
  app = "redditCrawler"

  default_tags = {
    terraform = "true"
    project = local.app,
    service = "main"
    stage = local.stage
  }
}
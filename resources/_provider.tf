provider "aws" {
  region = "eu-west-1"
  profile = "privateGmail"
  default_tags {
    tags = local.default_tags
  }
}
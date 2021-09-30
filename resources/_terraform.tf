terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "ke-terraform-backends"
    key = "state/reddit/crawler_service.prod.tfstate"
    region = "eu-west-1"
    profile = "privateGmail"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-west-1"
  profile = "privateGmail"
  default_tags {
    tags = local.default_tags
  }
}
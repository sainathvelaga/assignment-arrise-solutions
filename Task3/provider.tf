terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.account_a_profile
}

provider "aws" {
  alias   = "account_b"
  region  = var.aws_region
  profile = var.account_b_profile
}
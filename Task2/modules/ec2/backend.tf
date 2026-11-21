terraform {
  backend "s3" {
    bucket         = "assignment-arrise-solutions-tfstate-760081991615"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

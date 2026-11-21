variable "region" {
  description = "AWS region for the state bucket (use the same region as the main stack)"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Name prefix for the bucket and IAM role"
  type        = string
  default     = "assignment-arrise-solutions"
}
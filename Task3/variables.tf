
variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "us-east-1"
}

variable "account_a_id" {
  description = "AWS Account A ID"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_a_id))
    error_message = "Account A ID must contain exactly 12 digits."
  }
}

variable "account_b_id" {
  description = "AWS Account B ID"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_b_id))
    error_message = "Account B ID must contain exactly 12 digits."
  }
}

variable "account_a_profile" {
  description = "AWS CLI profile for Account A"
  type        = string
  default     = "account-a"
}

variable "account_b_profile" {
  description = "AWS CLI profile for Account B"
  type        = string
  default     = "account-b"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name in Account B"
  type        = string
}

variable "group2_usernames" {
  description = "Human IAM users in group2"
  type        = set(string)
  default     = ["Ram", "Sainath"]
}

resource "aws_iam_policy" "ci_least_privilege" {
  name        = "ci-least-privilege-policy"
  description = "Allows CI to push to one ECR repository, deploy to one ECS service, and read one S3 bucket."

  policy = file("${path.module}/ci-policy.json")
}

resource "aws_iam_user_policy_attachment" "ci_policy" {
  user       = aws_iam_user.ci.name
  policy_arn = aws_iam_policy.ci_least_privilege.arn
}

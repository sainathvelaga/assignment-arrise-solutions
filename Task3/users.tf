
resource "aws_iam_group" "group1" {
  name = "group1"
}

resource "aws_iam_group" "group2" {
  name = "group2"
}

# Programmatic users
resource "aws_iam_user" "engine" {
  name = "engine"
}

resource "aws_iam_user" "ci" {
  name = "ci"
}

# Human users
resource "aws_iam_user" "group2_users" {
  for_each = var.group2_usernames

  name = each.value
}

# Group memberships
resource "aws_iam_user_group_membership" "engine" {
  user   = aws_iam_user.engine.name
  groups = [aws_iam_group.group1.name]
}

resource "aws_iam_user_group_membership" "ci" {
  user   = aws_iam_user.ci.name
  groups = [aws_iam_group.group1.name]
}

resource "aws_iam_user_group_membership" "group2_users" {
  for_each = var.group2_usernames

  user   = aws_iam_user.group2_users[each.value].name
  groups = [aws_iam_group.group2.name]
}

output "created_iam_users" {
  value = concat(
    [aws_iam_user.engine.name, aws_iam_user.ci.name],
    [for user in aws_iam_user.group2_users : user.name]
  )
}

output "created_iam_groups" {
  value = [
    aws_iam_group.group1.name,
    aws_iam_group.group2.name
  ]
}

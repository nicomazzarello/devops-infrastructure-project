locals {
  developer_users = [for user in var.developer_usernames : "arn:aws:iam::${var.aws_account}:user/${user}"]
  devops_users    = [for user in var.devops_usernames    : "arn:aws:iam::${var.aws_account}:user/${user}"]
}
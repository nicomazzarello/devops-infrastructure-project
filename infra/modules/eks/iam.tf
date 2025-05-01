data "aws_iam_policy_document" "developer_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = local.developer_users
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "devops" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = local.developer_users
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "developer" {
  name               = "developer-access-role"
  assume_role_policy = data.aws_iam_policy_document.developer_assume_role.json
}

resource "aws_iam_role" "devops" {
  name               = "devops-access-role"
  assume_role_policy = data.aws_iam_policy_document.devops.json
}
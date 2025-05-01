resource "aws_iam_policy" "aurora_secret_access" {
  name        = "AuroraSecretAccessPolicy"
  description = "Allow read access to Aurora DB password"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["secretsmanager:GetSecretValue"],
        Resource = "arn:aws:secretsmanager:${var.region}:${var.aws_account}:secret:aurora-master-*"
      }
    ]
  })
}

resource "aws_iam_role" "irsa" {
  name = "eks-irsa-aurora-app"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = module.eks.cluster_oidc_issuer_url
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${module.eks.cluster_oidc_issuer_url}:sub" = "system:serviceaccount:default:aurora-app-sa"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.irsa.name
  policy_arn = aws_iam_policy.aurora_secret_access.arn
}

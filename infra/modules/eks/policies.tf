resource "aws_iam_policy" "asg-policy" {
  name        = "AmazonEKS_ASG_Policy"
  path        = "/"
  description = "Access policy to allow EKS to auto scale the worker nodes"
  policy = jsonencode(
      {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup"
        ],
        "Resource": ["*"]
      },
      {
        "Effect": "Allow",
        "Action": [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ],
        "Resource": ["*"]
      }
    ]
  }
)
}

resource "aws_iam_role_policy_attachment" "eks-aws-iam-role-asg-policy" {
  role       = module.eks.cluster_iam_role_name
  policy_arn = aws_iam_policy.asg-policy.arn
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.36"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true
  enable_irsa                     = true
  subnet_ids      = var.private_subnet_ids
  vpc_id          = var.vpc_id

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]

      additional_tags = {
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
        "k8s.io/cluster-autoscaler/enabled"             = "true"
      }
    }
  }

  access_entries = {
    developer = {
      kubernetes_groups = ["developers"]
      principal_arn     = aws_iam_role.developer.arn
      policy_associations = {
        eks = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

          access_scope = {
            type       = "namespace"
            namespaces = ["default"]
          }
        }
      }
    }
    devops = {
      kubernetes_groups = ["devops"]
      principal_arn     = aws_iam_role.devops.arn
      policy_associations = {
        eks = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"

          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = {
    Environment = "development"
    Terraform   = "true"
    Owner       = "Nicolas Kiu"
    Name        = var.cluster_name,
  }
}

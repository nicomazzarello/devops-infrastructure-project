terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      version = "~> 2.36"
    }
  }

  backend "s3" {
    bucket = "kiu-assignment-terraform-state"
    key    = "devops-assignment/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = data.eks.cluster.endpoint
  cluster_ca_certificate = base64decode(data.eks.cluster.certificate_authority.0.data)
  token                  = data.eks.cluster.token
}

module "network" {
  source = "./modules/network"
  vpc_name = "kiu-dev-vpc"
  region   = var.region
}

module "eks" {
  source = "./modules/eks"
  aws_account = var.aws_account
  cluster_name = "kiu-eks-dev-cluster"
  vpc_id       = module.network.vpc_id
  region       = var.region
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids = module.network.public_subnet_ids
  depends_on = [module.network]  
  developer_usernames  = var.developer_usernames
  devops_usernames     = var.devops_usernames
}

module "rds" {
  source = "./modules/rds"
  master_username = var.db_username
  region = var.region
  vpc_id = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids
  depends_on = [module.network]
  db_name = var.db_name
  cluster_name = var.db_cluster_name
}

module "nginx_controller" {
  source = "./modules/nginx-controller"
  ingress_class_name        = "nginx"
  ingress_class_is_default  = true
}

module "cert_manager" {
  source = "./modules/cert-manager"
}

data "aws_caller_identity" "current" {}


locals {
  aws_account = coalesce(var.aws_account, data.aws_caller_identity.current.account_id)
}
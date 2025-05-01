variable "aws_account" {
  type        = string
  description = "AWS acount ID"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "developer_usernames" {
  type        = list(string)
  description = "List of developer IAM usernames"
}

variable "devops_usernames" {
  type        = list(string)
  description = "List of devops IAM usernames"
}

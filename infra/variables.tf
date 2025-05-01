variable "aws_account" {
  type        = string
  description = "AWS account ID (optional override)"
}

variable "db_username" {
  description = "RDS Master username"
  type        = string
  default     = "admin"
}

variable "db_cluster_name" {
  description = "RDS cluster name"
  type        = string
  default     = "weatherapp-db-cluster"
}

variable "db_name" {
  description = "RDS default database name"
  type        = string
  default     = "weatherapp"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "developer_usernames" {
  type    = list(string)
  default = ["developer-user-1", "developer-user-2", "developer-user-3"]
}

variable "devops_usernames" {
  type    = list(string)
  default = ["nmazzarello", "devops-user-2", "devops-user-3"]
}

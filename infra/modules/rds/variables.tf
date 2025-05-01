variable "cluster_name" {
  type        = string
  description = "Name of the RDS cluster"
}

variable "db_name" {
  type        = string
  description = "Name of the RDS cluster"
}

variable "master_username" {
  type        = string
  description = "Master Username for Aurora PostgreSQL"
}
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for DB"
}

variable "region" {
  type        = string
}

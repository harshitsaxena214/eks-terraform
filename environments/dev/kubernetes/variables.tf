variable "aws_region" {
  description = "AWS region (must match the infra layer)"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name (must match the infra layer)"
  type        = string
  default     = "eks-three-stage"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = <<-EOT
    Name of the existing EKS cluster.
    Copy this value from: cd ../infra && terraform output eks_cluster_name
  EOT
  type        = string
}

variable "app_replica_count" {
  description = "Number of NGINX pod replicas to run"
  type        = number
  default     = 2
}


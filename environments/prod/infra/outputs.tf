output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "EKS cluster name â€” copy into kubernetes/terraform.tfvars as cluster_name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API server endpoint (informational)"
  value       = module.eks.cluster_endpoint
}

output "lbc_role_arn" {
  description = "IAM role ARN for the AWS Load Balancer Controller (informational)"
  value       = module.lbc_irsa.iam_role_arn
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint (host:port)"
  value       = module.rds.db_instance_endpoint
}

output "rds_db_name" {
  description = "PostgreSQL database name"
  value       = module.rds.db_instance_name
}

output "kubectl_config_command" {
  description = "Run this to configure kubectl after infra is deployed"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}


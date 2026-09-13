output "app_namespace" {
  description = "Kubernetes namespace where the application is deployed"
  value       = module.kubernetes_app.namespace
}

output "app_deployment_name" {
  description = "Kubernetes Deployment name"
  value       = module.kubernetes_app.deployment_name
}

output "app_ingress_name" {
  description = "Kubernetes Ingress name"
  value       = module.kubernetes_app.ingress_name
}

output "get_alb_command" {
  description = "Run this to get the ALB hostname (may take 2-3 min after apply)"
  value       = "kubectl get ingress nginx-app -n app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}


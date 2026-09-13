output "namespace" {
  description = "Kubernetes namespace where the application is deployed"
  value       = kubernetes_namespace.app.metadata[0].name
}

output "deployment_name" {
  description = "Name of the Kubernetes Deployment"
  value       = kubernetes_deployment.app.metadata[0].name
}

output "service_name" {
  description = "Name of the Kubernetes Service"
  value       = kubernetes_service.app.metadata[0].name
}

output "ingress_name" {
  description = "Name of the Kubernetes Ingress"
  value       = kubernetes_ingress_v1.app.metadata[0].name
}


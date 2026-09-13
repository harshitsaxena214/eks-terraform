variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "app_name" {
  description = "Application name used for resource naming and labels"
  type        = string
  default     = "nginx-app"
}

variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "app"
}

variable "replica_count" {
  description = "Number of pod replicas to run"
  type        = number
  default     = 2
}


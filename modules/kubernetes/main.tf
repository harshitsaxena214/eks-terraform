terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = var.namespace

    labels = {
      app         = var.app_name
      environment = var.environment
      managed-by  = "terraform"
    }
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.app.metadata[0].name

    labels = {
      app         = var.app_name
      environment = var.environment
    }
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app         = var.app_name
          environment = var.environment
        }
      }

      spec {
        container {
          name  = var.app_name
          image = "nginx:stable-alpine"

          port {
            container_port = 80
          }

          # Resource requests and limits â€” good practice in every deployment
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          # Readiness probe â€” ALB only sends traffic to healthy pods
          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }

          # Liveness probe â€” Kubernetes restarts unhealthy pods
          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 10
            period_seconds        = 30
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.app.metadata[0].name

    labels = {
      app         = var.app_name
      environment = var.environment
    }
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.app.metadata[0].name

    annotations = {
      # This tells the AWS LBC that it should handle this Ingress
      "kubernetes.io/ingress.class" = "alb"

      # Create an internet-facing ALB (not internal)
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"

      # Use IP target mode â€” routes traffic directly to pod IPs
      "alb.ingress.kubernetes.io/target-type" = "ip"

      # The public subnets where the ALB will be placed
      # The AWS LBC automatically discovers them via subnet tags
    }

    labels = {
      app         = var.app_name
      environment = var.environment
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.app.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}


module "kubernetes_app" {
  source = "../../../modules/kubernetes"

  environment   = var.environment
  app_name      = "nginx-app"
  namespace     = "app"
  replica_count = var.app_replica_count

  # LBC must be running before the Ingress is created, otherwise no ALB
  # is provisioned for it.
  depends_on = [helm_release.lbc]
}


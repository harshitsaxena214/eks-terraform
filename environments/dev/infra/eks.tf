module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${local.name_prefix}-cluster"
  cluster_version = var.kubernetes_version

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # Public endpoint Ã¢â‚¬â€ lets you run kubectl from your laptop
  cluster_endpoint_public_access = true

  # Essential cluster add-ons managed by AWS
  cluster_addons = {
    vpc-cni            = { most_recent = true } # Pod networking
    coredns            = { most_recent = true } # Cluster DNS
    kube-proxy         = { most_recent = true } # Network rules
    aws-ebs-csi-driver = { most_recent = true } # EBS volume support
  }

  # DEV: 1 node, t3.medium
  eks_managed_node_groups = {
    main = {
      name           = "${local.name_prefix}-nodes"
      instance_types = [var.node_instance_type]
      ami_type       = "AL2_x86_64"

      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      subnet_ids = module.vpc.private_subnets

      labels = {
        environment = var.environment
        nodegroup   = "main"
      }
    }
  }

  enable_cluster_creator_admin_permissions = true
}


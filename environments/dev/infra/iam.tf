# Fetch the official LBC IAM policy JSON from the kubernetes-sigs project
data "http" "lbc_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json"
}

resource "aws_iam_policy" "lbc" {
  name        = "${local.name_prefix}-lbc-policy"
  description = "IAM policy for the AWS Load Balancer Controller"
  policy      = data.http.lbc_iam_policy.response_body
}

# IRSA module creates an IAM role with an OIDC trust policy scoped to
# exactly one Kubernetes ServiceAccount in one namespace
module "lbc_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${local.name_prefix}-lbc-role"

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  role_policy_arns = {
    lbc = aws_iam_policy.lbc.arn
  }
}


module "eks" {
  depends_on = [
    aws_subnet.vpc_private_subnets,
    aws_subnet.vpc_public_subnets,

  ]

  source          = "terraform-aws-modules/eks/aws"
  version         = "20.15.0"
  cluster_name    = "eks-${var.product}-${var.environment}"
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [for subnet in aws_subnet.vpc_private_subnets : "${subnet.id}"]

  eks_managed_node_groups = {
    active = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      ami_type       = "AL2023_x86_64_STANDARD"
      capacity_type  = "SPOT"
    }
  }

  enable_cluster_creator_admin_permissions = true
}

data "aws_region" "current" {}

resource "null_resource" "update_kubeconfig" {
  depends_on = [
    module.eks
  ]
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command     = "aws eks --region ${data.aws_region.current.name} update-kubeconfig --name ${module.eks.cluster_name}"
    interpreter = ["bash", "-c"]
  }
}

data "aws_eks_cluster_auth" "current_cluster" {
  depends_on = [
    module.eks
  ]

  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }

}

resource "null_resource" "metrics_server" {
  depends_on = [
    null_resource.update_kubeconfig
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command     = "kubectl apply --validate=false -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
    interpreter = ["bash", "-c"]
  }
}

module "lb_role" {
  depends_on = [
    null_resource.metrics_server
  ]

  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "eks-${var.product}-${var.environment}_lb_role"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "kubernetes_service_account" "service_account" {
  depends_on = [
    module.lb_role
  ]

  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }

    annotations = {
      "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

provider "helm" {
  repository_config_path = "${path.module}/.helm/repositories.yaml"
  repository_cache       = "${path.module}/.helm"
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }

}

resource "helm_release" "alb_controller" {
  depends_on = [
    kubernetes_service_account.service_account
  ]

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"


  set {
    name  = "region"
    value = data.aws_region.current.name
  }

  set {
    name  = "vpcId"
    value = aws_vpc.vpc.id
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }
}

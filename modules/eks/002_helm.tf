######################################################################################################################
# Kubernetes
######################################################################################################################
# 모듈의 eks cluster name
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks
  ]
}
 
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks
  ]
}

provider "kubernetes" {
  alias                  = "adas-eks"
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}


######################################################################################################################
# 헬름차트
# 쿠버네티스 클러스터 추가 될때마다 alias 를 변경해서 추가해주기
######################################################################################################################
provider "helm" {
  alias = "adas-eks-helm"

  kubernetes {
    host                   = module.eks.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.adas-eks.token
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  }

}
########################################################################################
#   Helm release
########################################################################################
resource "helm_release" "eks_common_alb" {
  provider   = helm.adas-eks-helm
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  version    = "1.6.2"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"


  dynamic "set" {
    for_each = {
      "clusterName"                                               = var.cluster-name
      "serviceAccount.create"                                     = "true"
      "serviceAccount.name"                                       = local.lb_controller_service_account_name
      "region"                                                    = "ap-northeast-2"
      "vpcId"                                                     = data.aws_vpc.eks_vpc.id
      "image.repository"                                          = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/amazon/aws-load-balancer-controller"
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.adas_eks_lb_controller_role.iam_role_arn
    }


    content {
      name  = set.key
      value = set.value
    }
  }
}


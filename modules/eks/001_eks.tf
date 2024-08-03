#########################################################################################################
## Create eks cluster
#########################################################################################################
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.0"

  cluster_name    = var.cluster-name
  cluster_version = var.cluster-version
 
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      cluster_name = var.cluster-name
      most_recent = true
    }
    aws-ebs-csi-driver = {
      cluster_name             = var.cluster-name
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
    aws-efs-csi-driver = {
      cluster_name             = var.cluster-name
      service_account_role_arn = module.efs_csi_irsa_role.iam_role_arn
    }
  }

  vpc_id                   = data.aws_vpc.eks_vpc.id
  subnet_ids               = data.aws_subnets.eks_subnet.ids
  
  # EKS Managed Node Group
  eks_managed_node_group_defaults = {
    instance_types = ["t2.medium"]
  }
 

  eks_managed_node_groups = {
    backend = {
      name           = "stg-backend-nodegroup"
      subnet_ids     = data.aws_subnets.backend_node_subnet.ids

      min_size       = 1
      max_size       = 3
      desired_size   = 2

      instance_types = ["t2.medium"]
    }
  }
}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 4.12"


  role_name_prefix      = "VPC-CNI-IRSA"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true


  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
    common = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}


module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"


  role_name             = "ebs-csi"
  attach_ebs_csi_policy = true


  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}


module "efs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"


  role_name             = "efs-csi"
  attach_efs_csi_policy = true


  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
  }
}

############################################################################################
## lb_controller
############################################################################################


######################################################################################################################
# Set locals: lb_controller
######################################################################################################################
locals {
  # data-eks 를 위한 role name
  adas_eks_lb_controller_iam_role_name = "adas-eks-aws-lb-controller-role"


  k8s_aws_lb_service_account_namespace = "kube-system"
  lb_controller_service_account_name   = "aws-load-balancer-controller"
}


######################################################################################################################
# EKS 클러스터 인증 데이터 소스 추가
######################################################################################################################

data "aws_eks_cluster_auth" "adas-eks" {
  name = var.cluster-name
}

######################################################################################################################
# Load Balancer Controller ROLE 설정
######################################################################################################################

# load balancer controller에 role을 부여하도록 설정함.
module "adas_eks_lb_controller_role" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version     = "v5.1.0"
  create_role = true


  # 아래의 경로에 존재하는 role을 사용할 것임.
  role_name        = local.adas_eks_lb_controller_iam_role_name
  role_path        = "/"
  role_description = "Used by AWS Load Balancer Controller for EKS"


  role_permissions_boundary_arn = ""


  provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${local.k8s_aws_lb_service_account_namespace}:${local.lb_controller_service_account_name}"
  ]
  oidc_fully_qualified_audiences = [
    "sts.amazonaws.com"
  ]
}


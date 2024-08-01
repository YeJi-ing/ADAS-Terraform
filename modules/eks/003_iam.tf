######################################################################################################################
# IAM Policy 설정
######################################################################################################################
data "http" "iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.6.2/docs/install/iam_policy.json"
}

resource "aws_iam_role_policy" "adas-eks-controller" {
  name_prefix = "AWSLoadBalancerControllerIAMPolicy"
  role        = module.adas_eks_lb_controller_role.iam_role_name
  policy      = data.http.iam_policy.response_body
}
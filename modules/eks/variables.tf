#########################################################################################################
## EKS Variable
#########################################################################################################

variable "cluster-name" {
  description = "AWS kubernetes cluster name"
}

variable "cluster-version" {
  description = "AWS EKS supported Cluster Version to current use"
  default     = "1.27"
}

variable "vpc_name" {
  type = string
}

data "aws_vpc" "eks_vpc"{
  filter {
     name = "tag-key"
     values = ["Name"]
   }
  filter {
     name = "tag-value"
     values = ["${var.vpc_name}"]
   }
}

data "aws_subnets" "eks_subnet" { 
    filter {
     name = "tag-key"
     values = ["kubernetes.io/cluster/${var.cluster-name}"]
   }
   filter {
     name = "tag-value"
     values = ["shared"]
   }
}

data "aws_subnets" "backend_node_subnet" { 
  filter {
    name = "tag:Name"
    values = ["stg-ehr-subnet-pri01a", "stg-ehr-subnet-pri01c"]
  }
}
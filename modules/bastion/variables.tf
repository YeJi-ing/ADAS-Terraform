# a location where key_pair should be located
variable "pem_location" {
  type    = string
  default = "."
}

# pem key name
variable "key_name" {
  type    = string
}

# bastion name
variable "bastion_name" {
  type    = string
}

# iam_role name
variable "iam_role_name" {
  type    = string
}

# iam_instance_profile name
variable "iam_instance_profile_name" {
  type    = string
}

variable "vpc_name" {
  type = string
}

data "aws_vpc" "bastion_vpc"{
  filter {
     name = "tag-value"
     values = ["${var.vpc_name}"]
   }
   filter {
     name = "tag-key"
     values = ["Name"]
   }
}

variable "subnet_name" {
  type = string
}

data "aws_subnet" "bastion_subnet"{
    vpc_id = data.aws_vpc.bastion_vpc.id
    filter {
     name = "tag:Name"
     values = ["${var.subnet_name}"]
   }
}

###################################################
variable "cluster-name" {
  description = "AWS kubernetes cluster name"
}

variable "cluster-version" {
  description = "AWS EKS supported Cluster Version to current use"
  default     = "1.27"
}
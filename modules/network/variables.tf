variable "vpc_name" {
    type = string
}

variable "public_subnet_a_name" {
    type = string
}

variable "public_subnet_c_name" {
    type = string
}

variable "private_subnet_01a_name" {
    type = string
}

variable "private_subnet_01c_name" {
    type = string
}

variable "private_subnet_02a_name" {
    type = string
}

variable "private_subnet_02c_name" {
    type = string
}

variable "internet_gateway_name" {
    type = string
}

variable "nat_gateway_a_name" {
    type = string
}

variable "nat_gateway_c_name" {
    type = string
}

variable "public_rtb_a_name" {
  type= string
}

variable "public_rtb_c_name" {
  type= string
}

variable "private_rtb_01a_name" {
  type= string
}

variable "private_rtb_01c_name" {
  type= string
}
variable "private_rtb_02a_name" {
  type= string
}

variable "private_rtb_02c_name" {
  type= string
}

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
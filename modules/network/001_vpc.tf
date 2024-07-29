#########################################################################################################
## Create a VPC
#########################################################################################################
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}"
  }
}

#########################################################################################################
## Create Internet gateway & Nat gateway
#########################################################################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.internet_gateway_name}"
  }
}

resource "aws_eip" "nat-eip-a" {
  domain = "vpc"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "nat-eip-c" {
  domain = "vpc"
  lifecycle {
    create_before_destroy = true
  }
}
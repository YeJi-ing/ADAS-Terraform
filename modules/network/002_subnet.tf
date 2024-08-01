#########################################################################################################
## Create Public & Private Subnet
#########################################################################################################
resource "aws_subnet" "public-subnet-a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.public_subnet_a_name}"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/elb"                               = "1"
  }
}

resource "aws_subnet" "public-subnet-c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.public_subnet_c_name}"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/elb"                               = "1"
  }
}

resource "aws_subnet" "private-subnet-01a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name                                        = "${var.private_subnet_01a_name}"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb"                      = "1"
  }
}

resource "aws_subnet" "private-subnet-01c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name                                        = "${var.private_subnet_01c_name}"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb"                      = "1"
  }
}

resource "aws_subnet" "private-subnet-02a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name                                        = "${var.private_subnet_02a_name}"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb"                      = "1"
  }
}

resource "aws_subnet" "private-subnet-02c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name                                        = "${var.private_subnet_02c_name}"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb"                      = "1"
  }
}

####################################################
## NAT GATEWAY 
####################################################
resource "aws_nat_gateway" "nat-gateway-a" {
  subnet_id     = aws_subnet.public-subnet-a.id
  allocation_id = aws_eip.nat-eip-a.id
  tags = {
    Name = "${var.nat_gateway_a_name}"
  }
}

resource "aws_nat_gateway" "nat-gateway-c" {
  subnet_id     = aws_subnet.public-subnet-c.id
  allocation_id = aws_eip.nat-eip-c.id
  tags = {
    Name = "${var.nat_gateway_c_name}"
  }
}
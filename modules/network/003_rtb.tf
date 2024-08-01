#########################################################################################################
## Create Route Table & Route
#########################################################################################################
resource "aws_route_table" "public-rtb-a" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.public_rtb_a_name}"
  }
}


resource "aws_route_table" "public-rtb-c" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.public_rtb_c_name}"
  }
}

resource "aws_route_table_association" "public-rtb-assoc-a" {
  route_table_id = aws_route_table.public-rtb-a.id
  subnet_id      = aws_subnet.public-subnet-a.id
}

resource "aws_route_table_association" "public-rtb-assoc-c" {
  route_table_id = aws_route_table.public-rtb-c.id
  subnet_id      = aws_subnet.public-subnet-c.id
}

################################################
## web-was private subnet
################################################ 
resource "aws_route_table" "private-rtb-01a" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-a.id
  }
  tags = {
    Name = "${var.private_rtb_01a_name}"
  }
}

resource "aws_route_table" "private-rtb-01c" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-c.id
  }
  tags = {
    Name = "${var.private_rtb_01c_name}"
  }
}

resource "aws_route_table_association" "private-rtb-assoc-01a" {
  route_table_id = aws_route_table.private-rtb-01a.id
  subnet_id      = aws_subnet.private-subnet-01a.id
}

resource "aws_route_table_association" "private-rtb-assoc-01c" {
  route_table_id = aws_route_table.private-rtb-01c.id
  subnet_id      = aws_subnet.private-subnet-01c.id
}

################################################
## db private subnet
################################################ 
resource "aws_route_table" "private-rtb-02a" {
  vpc_id = aws_vpc.vpc.id
  # 얘 추가해라.
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-a.id
  }
  tags = {
    Name = "${var.private_rtb_02a_name}"
  }
}

resource "aws_route_table" "private-rtb-02c" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-c.id
  }
  tags = {
    Name = "${var.private_rtb_02c_name}"
  }
}

resource "aws_route_table_association" "private-rtb-assoc-02a" {
  route_table_id = aws_route_table.private-rtb-02a.id
  subnet_id      = aws_subnet.private-subnet-02a.id
}

resource "aws_route_table_association" "private-rtb-assoc-02c" {
  route_table_id = aws_route_table.private-rtb-02c.id
  subnet_id      = aws_subnet.private-subnet-02c.id
}

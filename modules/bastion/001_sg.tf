#########################################################################################################
## Create Security Group
#########################################################################################################
# SSH 트래픽 허용
resource "aws_security_group" "allow-ssh-sg" {
  name        = "stg-ehr-sg01-pub01a"
  description = "allow ssh for prd-ehr-ec2-bastion-pub01a"
  vpc_id      = data.aws_vpc.bastion_vpc.id
}

# 모든 IP에서 SSH 포트(22)로 들어오는 트래픽 허용
resource "aws_security_group_rule" "allow-ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.allow-ssh-sg.id
  to_port           = 22
  type              = "ingress"
  description       = "ssh"
  cidr_blocks       = ["0.0.0.0/0"]
}

# HTTP 트래픽 허용
resource "aws_security_group" "allow-http-sg" {
  name        = "stg-ehr-sg02-pub01a"
  description = "allow all ports"
  vpc_id      = data.aws_vpc.bastion_vpc.id
}

# 모든 IP에서 HTTP 포트(80)로 들어오는 트래픽 허용
resource "aws_security_group_rule" "allow-http-ports" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.allow-http-sg.id
  to_port           = 0
  type              = "ingress"
  description       = "all ports"
  cidr_blocks       = ["0.0.0.0/0"]
}

# HTTP 포트(80)에서 모든 IP로 나가는 트래픽 허용
resource "aws_security_group_rule" "allow-http-ports-egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.allow-http-sg.id
  to_port           = 0
  type              = "egress"
  description       = "all ports"
  cidr_blocks       = ["0.0.0.0/0"]
}

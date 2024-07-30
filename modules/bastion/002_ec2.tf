#########################################################################################################
## Create keypair for ec2
#########################################################################################################
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.key_name}"
  public_key = tls_private_key.private_key.public_key_openssh
}

# Download key file in local
resource "local_file" "pem_key" {
  filename        = "${var.pem_location}/${var.key_name}"
  content         = tls_private_key.private_key.private_key_pem
  file_permission = "0400"
}

output "pem_location" {
  value = local_file.pem_key.filename
}

#########################################################################################################
## Create ec2 instance for Bastion
#########################################################################################################

#aws_iam_instance_profile은 IAM 역할을 위한 컨테이너로서 인스턴스 시작 시 EC2 인스턴스에 역할 정보를 전달하는 데 사용됩니다. 
# 만약 AWS Management 콘솔을 사용하여 Amazon EC2 역할을 생성하는 경우, 
# 콘솔이 자동으로 인스턴스 프로파일을 생성하여 해당 역할과 동일한 이름을 부여합니다.
resource "aws_iam_instance_profile" "bastion_base_profile" {
  name = "${var.iam_instance_profile_name}"
  role = aws_iam_role.ec2_role.name   
}


resource "aws_instance" "bastion" {
  ami           = "ami-02422f4348cf351df"
  instance_type = "t2.medium"
  subnet_id     = data.aws_subnet.bastion_subnet.id

  iam_instance_profile = aws_iam_instance_profile.bastion_base_profile.name
  key_name             = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [
    aws_security_group.allow-ssh-sg.id,
    aws_security_group.allow-http-sg.id
  ]

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y yum-utils
  sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
  sudo yum -y install terraform
  curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
  echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
  sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
  sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens  
  EOF
  tags = {
    Name = "${var.bastion_name}"
  }
}

# Check bastion public ip
output "bastion-public-ip" {
  value = aws_instance.bastion.public_ip
}

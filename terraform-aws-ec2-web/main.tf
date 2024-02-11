terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
# Reminder: Don't share the access_key and secret_key, remove the keys before publishing in public repo.

provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}


# 1. Create an AWS VPC
resource "aws_vpc" "tf_env_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tf_env_vpc"
  }
}

# 2. Create an AWS Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.tf_env_vpc.id
  tags = {
    Name = "tf-env-gateway"
  }
}

# 3. Create Egress Internet Gateway
resource "aws_egress_only_internet_gateway" "egw" {
  vpc_id = aws_vpc.tf_env_vpc.id

  tags = {
    Name = "tf-egress-gw"
  }
}

# 3. Create an AWS Route Table
resource "aws_route_table" "tf_env_rt" {
  vpc_id = aws_vpc.tf_env_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.egw.id
  }

  tags = {
    Name = "tf-env-rt"
  }
}

# 4. Create an AWS Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.tf_env_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-env-subnet"
  }
}

# 5. Create a AWS Route Table Association
resource "aws_route_table_association" "route_table_assoc" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.tf_env_rt.id
}

# 6. Create a Security Group
# https://registry.terraform.io/providers/hashicorp/aws/3.44.0/docs/resources/security_group

resource "aws_security_group" "tf_sg_allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.tf_env_vpc.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tf_sg_allow_web"
  }
}

# 7. Create an AWS Network Interface
# https://registry.terraform.io/providers/-/aws/latest/docs/resources/network_interface

resource "aws_network_interface" "tf-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.tf_sg_allow_web.id]

  tags = {
    Name = "tf-nic"
  }

}

# 8. Assign an elastic IP to the network interface created in Step 7
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip.html
resource "aws_eip" "tf-eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.tf-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw]

  tags = {
    Name = "tf-elastic-ip"
  }
}

# 9. Create a AWS EC2 instance
resource "aws_instance" "tf-web-server-instance" {
  ami               = "ami-053b0d53c279acc90"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "tf-main-key"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.tf-nic.id
  }

  user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
sudo bash -c 'echo your very first web server > /var/www/html/index.html'
EOF

  tags = {
    Name = "tf-web-server"
  }
}

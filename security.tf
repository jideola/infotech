
# VPN subnet
resource "aws_security_group" "vpn_sg" {
  name        = "vpn_sg"
  description = "client in to VPN SG, ssh & icmp out to private"
  vpc_id =  aws_vpc.infotech-vpc.id

  ingress {
    description      = "TCP for vpn"
    from_port        = 1194
    to_port          = 1194
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "UDP for vpn"
    from_port        = 1194
    to_port          = 1194
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  ingress {
    description      = "SSH from private_subnet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpn_sg"
  }
}

# Public_proxy
resource "aws_security_group" "proxy_sg" {
  name        = "proxy_sg"
  description = "Proxy to private server"
  vpc_id =  aws_vpc.infotech-vpc.id

  ingress {
    description      = "Port 80 for Internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Port 8080 for Internet"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "ssh from vpn_sg"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.vpn_sg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "proxy_sg"
  }
}


# Private Subnet SG
resource "aws_security_group" "private_sg" {
  name        = "private_subnet_sg"
  description = "Access to private servers"
  vpc_id =  aws_vpc.infotech-vpc.id

  ingress {
    description      = "All cimp from within itself"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    self             = true
  }

  ingress {
    description      = "All cimp from vpn_sg"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    security_groups  = [aws_security_group.vpn_sg.id]
  }

  ingress {
    description      = "All TCP from self"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    self             = true
  }

  ingress {
    description      = "All tcp from vpn_sg"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    security_groups  = [aws_security_group.vpn_sg.id]
  }

  ingress {
    description      = "All UDP from vpn_sg"
    from_port        = 0
    to_port          = 65535
    protocol         = "udp"
    security_groups  = [aws_security_group.vpn_sg.id]
  }

  ingress {
    description      = "ssh from vpn_sg"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.vpn_sg.id]
  }

  ingress {
    description      = "All TCP  from proxy_sg"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    security_groups  = [aws_security_group.proxy_sg.id]
  }

  ingress {
    description      = "All UDP from proxy_sg"
    from_port        = 0
    to_port          = 65535
    protocol         = "udp"
    security_groups  = [aws_security_group.proxy_sg.id]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private_subnet_sg"
  }
}


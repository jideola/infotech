# Create a jenkins server in the private subnet
 resource "aws_instance" "jenkins" {
    ami = "ami-0219f0d71561107ac"
    instance_type = "t2.medium"
    subnet_id = aws_subnet.private[0].id
    vpc_security_group_ids = [aws_security_group.private_sg.id]
    key_name = "jideola_macbookpro"
  tags = {
  "Name" = "jenkins"
  }
}

# Create a Nexus server in the private subnet
 resource "aws_instance" "nexus" {
    ami = "ami-034dee81797549044"
    instance_type = "t2.medium"
    subnet_id = aws_subnet.private[0].id
    vpc_security_group_ids = [aws_security_group.private_sg.id]
    key_name = "jideola_macbookpro"
  tags = {
  "Name" = "nexus"
  }
}

# Create a SonarQube server in the private subnet
 resource "aws_instance" "sonarqube" {
    ami = "ami-0d6d4ddcf89600a15"
    instance_type = "t2.medium"
    subnet_id = aws_subnet.private[0].id
    vpc_security_group_ids = [aws_security_group.private_sg.id]
    key_name = "jideola_macbookpro"
  tags = {
  "Name" = "sonarqube"
  }
}

# Create an Nginx server
 resource "aws_instance" "nginx" {
    ami = "ami-00a2759650e783913"
    instance_type = var.instance_type
    subnet_id = aws_subnet.public[0].id
    vpc_security_group_ids = [aws_security_group.proxy_sg.id]
    key_name = "jideola_macbookpro"
  tags = {
  "Name" = "nginx"
  }
}

# Create a VPN server
 resource "aws_instance" "vpn_server" {
    ami = "ami-02ea247e531eb3ce6"
    instance_type = var.instance_type
    subnet_id = aws_subnet.public[0].id
    vpc_security_group_ids = [aws_security_group.vpn_sg.id]
    key_name = "jideola_macbookpro"
  tags = {
  "Name" = "vpn_server"
  }
}

# Create a Staging-App-server in the private subnet
 resource "aws_instance" "staging-app-server" {
  ami = "ami-070dfe9103fd1bb1b"
  instance_type = "t2.micro"
  key_name = "jideola_macbookpro"
    subnet_id = aws_subnet.private[0].id
    vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
  "Name" = "Staging-App-server"
  }
}

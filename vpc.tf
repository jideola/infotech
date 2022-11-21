# VPC
resource "aws_vpc" "infotech-vpc" {
  cidr_block       = var.vpc_cidr
  tags = {
    Name = "infotech"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "infotech_igw" {
  vpc_id = aws_vpc.infotech-vpc.id
  tags = {
    Name = "main"
  }
}

# Subnets : public
resource "aws_subnet" "public" {
  count = length(var.public_subnets_cidr)
  vpc_id = aws_vpc.infotech-vpc.id
  cidr_block = element(var.public_subnets_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet-${count.index+1}"
  }
}


# Route table: attach Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.infotech-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infotech_igw.id
  }
  tags = {
    Name = "publicRouteTable"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "public-rt-association" {
  count = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public.*.id,count.index)
  route_table_id = aws_route_table.public_rt.id
}

#------------------------------------------------------------


# Subnets : Private
resource "aws_subnet" "private" {
  count = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.infotech-vpc.id
  cidr_block = element(var.private_subnets_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  tags = {
    Name = "Private-Subnet-${count.index+1}"
  }
}

# Route table: attach Nat Gateway
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.infotech-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }
  tags = {
    Name = "privateRouteTable"
  }
}

# Route table association with private subnets
resource "aws_route_table_association" "private-rt-association" {
  count = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private.*.id,count.index)
  route_table_id = aws_route_table.private_rt.id
}

# Creating elastic ip
  resource "aws_eip" "nat_eIP" {
   vpc   = true
  tags = {
    Name = "EIP for NGW"
  }
 }
#*********************************************************************

 # Creating the NAT Gateway in private subnet and attach eip to it
 resource "aws_nat_gateway" "NATgw" {
  subnet_id      = aws_subnet.public[0].id
   allocation_id = aws_eip.nat_eIP.id
  tags = {
    Name = "NGW for private"
  }
 }

# Key_pair
 resource "aws_key_pair" "jideola_macbookpro" {
  key_name   = "jideola_macbookpro"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJwDeRBPJBC7uaM0PEM90tdZBgQmSzdFGPrx2S5lVyUaUxdw1lOlZBnIv/G2+7JulToU6MLBCPcVqPH/Pim5l9gV06JIrtRsrh5o50jUln40yfKvd9jNq/M1LmYzl6h5dQXEmsqxvglNlqyvtguO1ZWgZWuQemeNzSN5T/BAI+vam/FDbRzReC5TnksoGCjVHt2SLzUteSJJC8Qbn4NwWb1IQg9dWY0q9kmnah8mzA24gS9af0HPdACCttDvT7YKHCjZzf6m+0kK9jyrrSecEFVvcT4qMCaj7MzvRrApzweR2+wqi52bt5H5naaxIxlZJrxdG29fjPguZgWtAfc8QQZCtCYxzqwlt1LkqhVhUDYyBWFKF82OwETWy4GzOrzLAlm3NMwm7iYyaL55DKAwAXiqAzE8iuSVMjLwVPGCOoaRAXqOL1PNMUXYLDItZD14pbYu+xke6PxXARKkNXwhMv4aeRUfumzaa82ioBN0CTGFqfa3uUOwy/5AjmA9aQPRk= jideola@Jideolas-MBP.attlocal.net"
}

# creating an Elastic Load balancer
resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [
    aws_security_group.proxy_sg.id
  ]
  subnets = [aws_subnet.public[0].id,aws_subnet.public[1].id]

  cross_zone_load_balancing   = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }

}

# Creating an Auto-scalling group
resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}
# Creating a cloud watch alarm for cpu utilization
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_policy_up.arn ]
}
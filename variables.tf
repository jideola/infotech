variable "aws_region" {
	default = "us-west-1"
}

variable "vpc_cidr" {
	default = "172.16.0.0/16"
}

variable "public_subnets_cidr" {
	type = list
	default = ["172.16.0.0/28","172.16.1.0/28"]
}

variable "private_subnets_cidr" {
	type = list
	default = ["172.16.128.0/28", "172.16.192.0/28"]
}


variable "azs" {
	type = list
	default = ["us-west-1b", "us-west-1c"]
}
 variable "my_ami" {
    description = "The aws ami"
    type = string
    default = "ami-09d3b3274b6c5d4aa"
}

variable "instance_type" {
    description = "The ec2 instance type"
    type = string
    default ="t2.micro"
}
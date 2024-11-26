variable "name" {
    description = "name of application"
    type = string
    #default = "asyraf-with-prefix"
}

variable "vpc_id" {
    description = "vpc id"
    type = string
    #default = "vpc-067f3ab097282bc4d"
}

variable "subnet_id" {
    description = "subnet id"
    type = string
    #default = "vpc-067f3ab097282bc4d"
}

data "aws_subnets" "selected" {
    filter {
        name = "vpc-id"
        values = [var.vpc_id]
    }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

locals {
    department = "marketing"
}

resource "aws_instance" "public" {
  ami                         = "ami-04c913012f8977029"
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id  #Public Subnet ID, e.g. subnet-xxxxxxxxxxx
  associate_public_ip_address = true
  key_name                    = "asyraf-kp" #Change to your keyname, e.g. jazeel-key-pair
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
 
  tags = {
    Name = "${var.name}-ec2"
    Department = local.department    #Prefix your own name, e.g. jazeel-ec2
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "${var.name}-sg" #Security group name, e.g. jazeel-terraform-security-group
  description = "Allow SSH inbound"
  vpc_id      = var.vpc_id 
  lifecycle {
    create_before_destroy = true
  } #VPC ID (Same VPC as your EC2 subnet above), E.g. vpc-xxxxxxx
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"  
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

output "public_ip" {
    value = aws_instance.public.public_ip
}

output "public_dns" {
    value = aws_instance.public.public_dns
}

output "public_subnet_ids" {
    value = data.aws_subnets.public.ids
}

output "private_subnet_ids" {
    value = data.aws_subnets.private.ids
}
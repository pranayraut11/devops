provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"

  cidr = "10.0.0.0/16"
  name = "dev-vpc"
}

module "subnet_a" {
  source = "../../modules/subnet"

  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip     = true
  name              = "dev-subnet-a"
}

module "subnet_b" {
  source = "../../modules/subnet"

  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip     = true
  name              = "dev-subnet-b"
}

module "network" {
  source = "../../modules/network"

  vpc_id = module.vpc.vpc_id
  subnet_ids = [
    module.subnet_a.subnet_id,
    module.subnet_b.subnet_id
  ]
  name = "dev"
}

module "security_group" {
  source = "../../modules/security-group"

  vpc_id = module.vpc.vpc_id
  name   = "dev"

  my_ip = var.my_ip
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

locals {
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              service docker start
              usermod -a -G docker ec2-user
              docker run -d -p 80:80 nginx
              EOF
}

module "ec2_a" {
  source = "../../modules/ec2"

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  subnet_id = module.subnet_a.subnet_id
  sg_ids    = [module.security_group.ec2_sg_id]

  user_data = local.user_data
  name      = "dev-ec2-a"
}

module "ec2_b" {
  source = "../../modules/ec2"

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  subnet_id = module.subnet_b.subnet_id
  sg_ids    = [module.security_group.ec2_sg_id]

  user_data = local.user_data
  name      = "dev-ec2-b"
}

module "alb" {
  source = "../../modules/alb"

  name   = "dev-alb"
  vpc_id = module.vpc.vpc_id

  subnet_ids = [
    module.subnet_a.subnet_id,
    module.subnet_b.subnet_id
  ]

  sg_ids = [module.security_group.alb_sg_id]

  instance_ids = [
    module.ec2_a.instance_id,
    module.ec2_b.instance_id
  ]
}

module "route53" {
  source = "../../modules/route53"

  zone_id = var.zone_id   # your hosted zone id
  domain  = var.domain

  alb_dns     = module.alb.alb_dns
  alb_zone_id = module.alb.alb_zone_id
}
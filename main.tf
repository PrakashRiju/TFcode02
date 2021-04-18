provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "rijutfstate234"
    key = "global/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "vpc_networking" {
  source = "./vpc_networking"
  prv_subnet_cidr_block = var.prv_subnet_cidr_block
  pub_subnet_cidr_block = var.pub_subnet_cidr_block
  vpc_cidr_block = var.vpc_cidr_block
}

module "bastion_host" {
  source="./bastion_host"
  bastion_vpc_id = data.aws_vpc.alpha_vpc_id
  pub_subnet_id = data.aws_subnet.pub_subnet
}

module "ec2_instances" {
  source="./instances"
  EC2_instance_type = var.instance_type
  remote_state_bucket= var.remote_state_bucket
  remote_state_key_path= var.remote_state_bucket_key_path
  region = var.region
}


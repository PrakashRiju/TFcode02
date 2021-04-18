data "aws_subnet" "pub_subnet" {
  id = module.vpc_networking.pub_subnet_id
}

data "aws_vpc" "alpha_vpc_id" {
  id = module.vpc_networking.vpc_id
}
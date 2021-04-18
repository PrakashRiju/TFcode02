
resource "aws_vpc" "alpha_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "alpha_vpc"
    Provisioner = "terraform"
  }
}

resource "aws_subnet" "alpha_pub_subnet" {
  cidr_block = var.pub_subnet_cidr_block
  vpc_id = aws_vpc.alpha_vpc.id
  availability_zone = "${var.region}a"
  tags = {
    Name = "alpha_public_subnet"
    Provisioner = "terraform"
  }
}

resource "aws_subnet" "alpha_prv_subnet" {
  cidr_block = var.prv_subnet_cidr_block
  vpc_id = aws_vpc.alpha_vpc.id
  availability_zone = "${var.region}b"
  tags = {
    Name = "alpha_prv_subnet"
    Provisioner = "terraform"
  }
}

resource "aws_route_table" "alpha_public_rt" {
  vpc_id = aws_vpc.alpha_vpc.id
}

resource "aws_route_table" "alpha_private_rt" {
  vpc_id = aws_vpc.alpha_vpc.id
}

resource "aws_route_table_association" "public_route_table_association" {
  route_table_id = aws_route_table.alpha_public_rt.id
  subnet_id = aws_subnet.alpha_pub_subnet.id
}

resource "aws_route_table_association" "private_route_table_association" {
  route_table_id = aws_route_table.alpha_private_rt.id
  subnet_id = aws_subnet.alpha_prv_subnet.id
}

//resource "aws_eip" "nat_eip" {
//  vpc = true
//}
//
//resource "aws_nat_gateway" "nat_gw" {
//  allocation_id = aws_eip.nat_eip.id
//  subnet_id = aws_subnet.alpha_pub_subnet.id
//}

//resource "aws_route" "nat_route" {
//  route_table_id = aws_route_table.alpha_private_rt.id
//  nat_gateway_id = aws_nat_gateway.nat_gw.id
//  destination_cidr_block = "0.0.0.0/0"
//}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.alpha_vpc.id
}

resource "aws_route" "igw_route" {
  route_table_id = aws_route_table.alpha_public_rt.id
  gateway_id = aws_internet_gateway.internet_gw.id
  destination_cidr_block = "0.0.0.0/0"
}





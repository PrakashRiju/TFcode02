terraform {
  backend "s3" {}
}

data "terraform_remote_state" "network_configuration" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = var.remote_state_key_path
    region = var.region
  }
}

resource "aws_security_group" "public_sg" {
  name        = "EC2 Public SG"
  description = "To access ec2 instances from the internet"
  vpc_id      = data.terraform_remote_state.network_configuration.outputs.main_vpc_id

  ingress {
    from_port=80
    protocol="tcp"
    to_port=80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port=22
    protocol="tcp"
    to_port=22
    cidr_blocks = ["122.177.122.61/32"]
  }
  egress {
    from_port=0
    protocol="-1"
    to_port=0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  name        = "EC2_private_sg"
  description = "To connect to instances in public subnet"
  vpc_id      = data.terraform_remote_state.network_configuration.outputs.main_vpc_id

  ingress {
    from_port=0
    protocol="-1"
    to_port=0
    security_groups = [aws_security_group.public_sg.id]
  }
  ingress {
    from_port=80
    protocol="tcp"
    to_port=80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port=0
    protocol="-1"
    to_port=0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb_sg" {
  name        = "ELB_sg"
  description = "To allow Load Balancers traffic"
  vpc_id      = data.terraform_remote_state.network_configuration.outputs.main_vpc_id

  ingress {
    from_port=0
    protocol="-1"
    to_port=0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port=0
    protocol="-1"
    to_port=0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "launch_configuration_ami" {
  most_recent = true
  owners = ["amazon"]
}

resource "aws_launch_configuration" "ec2_pvt_launch_configuration" {
  image_id      = data.aws_ami.launch_configuration_ami.id
  instance_type = var.EC2_instance_type
  key_name      = var.key_pair
  associate_public_ip_address = "false"
  security_groups = [aws_security_group.private_sg.id]
  user_data = <<EOF
      !/bin/bash
      yum update -y
      yum install -y httpd.x86_64
      systemctl start httpd.service
      systemctl enable httpd.service
      echo “Hello World from Production in private ” > /var/www/html/index.html
    EOF
}

resource "aws_launch_configuration" "ec2_pub_launch_configuration" {
  image_id      = data.aws_ami.launch_configuration_ami.id
  instance_type = var.EC2_instance_type
  key_name      = var.key_pair
  associate_public_ip_address = "false"
  security_groups = [aws_security_group.private_sg.id]
  user_data = <<EOF
      !/bin/bash
      yum update -y
      yum install -y httpd.x86_64
      systemctl start httpd.service
      systemctl enable httpd.service
      echo “Hello World from Web in Public ” > /var/www/html/index.html
    EOF
}

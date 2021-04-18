resource "aws_security_group" "bastion_sg" {
  name = "Bastion Sg"
  vpc_id = var.bastion_vpc_id.id
  ingress {
    from_port=22
    protocol="tcp"
    to_port=22
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
     from_port=0
     protocol=-1
     to_port=0
     cidr_blocks = ["0.0.0.0/0"]
   }
}

//resource "aws_instance" "alpha_bastion" {
//  ami="ami-032e5b6af8a711f30"
//  instance_type="t2.micro"
//  subnet_id = var.pub_subnet_id.id
//  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
//}


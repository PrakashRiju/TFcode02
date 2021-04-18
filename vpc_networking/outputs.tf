output "vpc_id" {
  description = "vpc id"
  value = aws_vpc.alpha_vpc.id
}

output "pub_subnet_id" {
  value = aws_subnet.alpha_pub_subnet.id
  description = "public subnet id"
}

output "prv_subnet_id" {
  value = aws_subnet.alpha_prv_subnet.id
  description = "private subnet id"
}

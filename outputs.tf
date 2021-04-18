output "main_vpc_id" {
  value= module.vpc_networking.vpc_id
}

output "pub_subnet_id" {
  value= module.vpc_networking.pub_subnet_id
}

output "prv_subnet_id" {
  value= module.vpc_networking.prv_subnet_id
}

/*output "bastion_id" {
  value= module.bastion_host.bastion
}*/

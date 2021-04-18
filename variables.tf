variable "region" {
  default = "eu-west-1"
}

variable "vpc_cidr_block" {}
variable "pub_subnet_cidr_block" {}
variable "prv_subnet_cidr_block" {}

variable "instance_type" {}
variable "remote_state_bucket" {}
variable "remote_state_bucket_key_path" {}

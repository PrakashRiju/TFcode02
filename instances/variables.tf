variable "EC2_instance_type" {
  description = "Instance type for ec2 server"
}

variable "key_pair" {
  default = "alpha_key"
}

variable "remote_state_bucket" {
  description = "S3 backend state file name"
}

variable "remote_state_key_path" {
  description = "S3 backend state bucket path"
}

variable "region" {}
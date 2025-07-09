variable "project" {}
variable "region" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "node_count" { default = 3 }
variable "machine_type" { default = "e2-medium" }
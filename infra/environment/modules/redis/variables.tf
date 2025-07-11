variable "project" {}
variable "memory_size" { default = 1 }
variable "name" {
  description = "Name of the Redis cluster"
  type        = string
  default     = "demo-app"
}

variable "shard_count" {
  description = "Number of shards in the Redis cluster"
  type        = number
  default     = 3
}

variable "region" {
  description = "Region for the Redis cluster"
  type        = string
  default     = "us-central1"
}

variable "replica_count" {
  description = "Number of replicas per shard"
  type        = number
  default     = 1
}

variable "network_id" {
  description = "VPC network ID"
  type        = string
}

variable "management_subnet_id" {
  description = "List of subnetworks for PSC config"
  type        = string
}

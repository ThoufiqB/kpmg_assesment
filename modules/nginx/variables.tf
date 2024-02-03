variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "cluster_name" {}

variable "nginx_replica_count" {
  type    = number
  default = 2
  description = "Number of Nginx replicas"
}

variable "nginx_image_version" {
  type    = string
  default = "stable"
  description = "Nginx image version"
}
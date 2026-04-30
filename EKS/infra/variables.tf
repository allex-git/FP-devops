variable "name" {
  description = "Cluster name"
}

variable "region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "iam_profile" {
  description = "AWS CLI profile"
  default     = null
}

variable "vpc_cidr" {}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "zone_name" {}

variable "tags" {
  type = map(string)
}

variable "created_by" {
  default = "Allex_DevOps"
}
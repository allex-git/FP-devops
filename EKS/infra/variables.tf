variable "name" {
  description = "Cluster name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "iam_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "zone_name" {
  description = "Route53 hosted zone name"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}

variable "created_by" {
  description = "Owner tag"
  type        = string
  default     = "Allex_DevOps"
}
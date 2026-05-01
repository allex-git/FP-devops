variable "name" {
  description = "Cluster name"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "region" {
  description = "aws region"
  type        = string
  default     = "eu-central-1"
}

variable "iam_profile" {
  description = "Profile of aws creds"
  type        = string
  default     = null
}

variable "zone_name" {
  description = "Route53 zone name"
  type        = string
}
variable "name" {
}

variable "tags" {
}

variable "region" {
  description = "aws region"
  default     = "eu-central-1"
}

variable "iam_profile" {
  description = "Profile of aws creds"
  default     = null
}

variable "zone_name" {
}

variable "created_by" {
  description = "Owner tag"
  type        = string
  default     = "Allex_DevOps"
}

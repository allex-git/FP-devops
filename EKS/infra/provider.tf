provider "aws" {
  region  = var.region
  profile = var.iam_profile

  default_tags {
    tags = {
      created_by = var.name
    }
  }
}

# Availability zones (для VPC)
data "aws_availability_zones" "available" {}
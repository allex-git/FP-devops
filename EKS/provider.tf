# AWS provider
provider "aws" {
  region  = var.region
  profile = var.iam_profile

  default_tags {
    tags = {
      created_by = var.name
    }
  }
}

# Availability zones
data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "danit" {
  name = aws_eks_cluster.danit.name
}


data "aws_eks_cluster_auth" "danit" {
  name = aws_eks_cluster.danit.name
}

# Kubernetes provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.danit.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.danit.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.danit.token
}

# Helm provider
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.danit.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.danit.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.danit.token
  }
}

# Terraform providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}
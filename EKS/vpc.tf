module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "6.6.1"

  name                 = "${var.name}-vpc"
  cidr                 = var.vpc_cidr

  azs                  = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnets       = var.public_subnets

  private_subnets      = var.private_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags   = {
    "kubernetes.io/role/elb" = "1"
    created_by               = "Allex_DevOps"
  }

  private_subnet_tags   = {
    "kubernetes.io/role/internal-elb"   = "1"
    created_by                          = "Allex_DevOps"
  }

  tags = merge(var.tags, {
    Name                                = "${var.name}-vpc"
    "kubernetes.io/cluster/${var.name}" = "shared"
    created_by                          = "Allex_DevOps"
  })
}
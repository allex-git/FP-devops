provider "aws" {
  region  = var.region
  profile = var.iam_profile
}

data "terraform_remote_state" "infra" {
  backend = "s3"

  config = {
    bucket = "tf-tfstate-danit-11"
    key    = "state/allex-devops/infra/terraform.tfstate" # CHANGED
    region = "eu-central-1"
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.infra.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.infra.outputs.cluster_ca)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.infra.outputs.cluster_name
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.infra.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.infra.outputs.cluster_ca)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.terraform_remote_state.infra.outputs.cluster_name
      ]
    }
  }
}
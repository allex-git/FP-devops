terraform {
  backend "s3" {
    bucket         = "tf-tfstate-danit-11"
    key            = "state/allex-devops/infra/terraform.tfstate" # CHANGED: отдельный state
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "allex-devops-lock-tf-eks"
  }
}
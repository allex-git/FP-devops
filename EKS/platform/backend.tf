terraform {
  backend "s3" {
    bucket         = "tf-tfstate-danit-11"
    key            = "state/allex-devops/platform/terraform.tfstate" # CHANGED
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "allex-devops-lock-tf-eks"
  }
}
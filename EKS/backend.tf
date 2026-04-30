terraform {
  backend "s3" {
    bucket = "tf-tfstate-danit-11"
    key = "state/allex-devops/final-project/terraform.tfstate"
    encrypt = true
    dynamodb_table = "allex-devops-lock-tf-eks"
  }
}
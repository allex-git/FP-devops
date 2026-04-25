terraform {
  backend "s3" {
    bucket         = "tf-tfstate-danit-11"
    key            = "state/allex-devops/final-project/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "lock-tf-eks"
  }
}



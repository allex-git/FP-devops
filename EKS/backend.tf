  terraform {
    backend "s3" {
      bucket         = "tf-tfstate-danit-11"
      key            = "state/allex-devops/infra/terraform.tfstate"
      encrypt        = true
      dynamodb_table = "allex-devops-lock-tf-eks"
      region         = "eu-central-1"
      # dynamo key LockID
      # Params tekan from -backend-config when terraform init
      #region = 
      #profile = 
    }
  }



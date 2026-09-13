terraform {
  backend "s3" {
    bucket  = "<YOUR_STATE_BUCKET_NAME>"
    key     = "prod/infra/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}


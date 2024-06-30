terraform {
  backend "s3" {
    bucket = "hartono-terraform-backend-non-prod"
    key    = "uat.tfstate"
    region = "ap-southeast-1"
  }
}

terraform {
  backend "s3" {
    bucket = "hartono-terraform-backend-non-prod"
    key    = "staging.tfstate"
    region = "ap-southeast-1"
  }
}

terraform {
  backend "s3" {
    bucket = "hartono-terraform-backend-prod"
    key    = "prod.tfstate"
    region = "ap-southeast-1"
  }
}

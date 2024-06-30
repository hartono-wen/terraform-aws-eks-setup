provider "aws" {
  region = "ap-southeast-1"
}

module "vpc_networking" {
  source = "../../modules/eks-from-scratch"

  environment              = var.environment
  product                  = var.product
  vpc_name                 = var.vpc_name
  vpc_cidr_block           = var.vpc_cidr_block
  vpc_private_subnet_lists = var.vpc_private_subnet_lists
  vpc_public_subnet_lists  = var.vpc_public_subnet_lists
  additional_tags          = var.additional_tags
}



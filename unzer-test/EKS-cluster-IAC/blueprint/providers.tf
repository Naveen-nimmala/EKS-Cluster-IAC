locals {
  region = "eu-west-1"
}

provider "aws" {
  region = local.region
}


terraform {
  required_version = "0.13.5" # see https://releases.hashicorp.com/terraform/
}

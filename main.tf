terraform {
  backend "s3" {
    encrypt = true
    key     = "tf-ntno.net.tfstate"
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  global_tags = {
    CreatedBy   = "https://github.com/ntno/tf-ntno.net"
    Provisioner = "Terraform"
    project     = "ntno.net"
    domain      = "personal"
  }
}
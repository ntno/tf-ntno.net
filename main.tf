terraform {
  backend "s3" {
    encrypt = true
    key     = "tf-ntno.net.tfstate"
  }
}

provider "aws" {
  region = var.region
}

provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  global_tags = {
    CreatedBy   = "ntno/tf-ntno.net"
    Provisioner = "Terraform"
    project     = "ntno.net"
    domain      = "personal"
  }
}
terraform {
  backend "s3" {
    region = "us-west-2"
    bucket = "lguerratest"
    key    = "gorilla-test/global.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.15.1"
    }
  }
  required_version = ">= 1.2"
}
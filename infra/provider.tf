provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Environment = "Production"
      CreatedBy   = "LGuerra"
      CreatedWith = "Terraform"
      Purpose     = "Gorilla logic team exam"
    }
  }
}
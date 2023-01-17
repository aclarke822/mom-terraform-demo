terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.47.0"
    }
  }
  
  backend "s3" {
    bucket = "mom8-remote-state-demo"
    key = "mom-demo"
    region = "us-east-1"
    dynamodb_table = ""
  }
  
  required_version = "~> 1.3.7"
}

provider "aws" {
  alias  = "region1"
  region = "us-east-1"
}
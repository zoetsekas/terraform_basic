terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile    = "zoe_aws_sandbox"
  region     = "us-west-2"
  shared_credentials_file = "C:\\Users\\zoets\\.aws\\credentials"
}

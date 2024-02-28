terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    key = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_route53_zone" "kube" {
  name = var.domain_name
}

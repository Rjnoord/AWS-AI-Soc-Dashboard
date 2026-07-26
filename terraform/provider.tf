# Terraform/provider version pin for this lab environment; keeps the
# committed .terraform.lock.hcl reproducible across machines.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Single-region AWS provider; region is parameterized via variable so the
# lab can be redeployed elsewhere without editing code.
provider "aws" {
  region = var.aws_region
}

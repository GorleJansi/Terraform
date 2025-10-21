# Define terraform {} block → Main Terraform configuration block. Defines required providers and backend settings.

terraform {
  required_providers {           # Specify the providers required for this Terraform configuration
    aws = {                      # The provider is AWS
      source  = "hashicorp/aws"  # Source location of the provider (official HashiCorp registry)
      version = "6.16.0"         # Version of the AWS provider to use
    }
  }

  backend "s3" {                              # Configure the backend to store Terraform state remotely
    bucket        = "roboshop1-remotestate"   # Name of the S3 bucket where state file will be stored
    key           = "dynamic-block-demo"      # Path inside the S3 bucket for this specific Terraform state
    region        = "us-east-1"               # AWS region where the S3 bucket exists
    use_lockfile  = true                      # Enables state locking to prevent concurrent modifications (Prevents two people from modifying state simultaneously.)
    encrypt       = true                      # Enable server-side encryption for the state file in S3
  }
}

provider "aws" {                        # Configure the AWS provider with region details
  region = "us-east-1"                  # Set the default AWS region for all resources managed by this provider
}


terraform 
{
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.16.0"
    }
   }

  backend "s3" {
    bucket        = "roboshop1-remotestate"   # Name of the S3 bucket where state file will be stored
    key           = "provider-block-demo"      # Path inside the S3 bucket for this specific Terraform state
    region        = "us-east-1"               # AWS region where the S3 bucket exists
    use_lockfile  = true                      # Enables state locking to prevent concurrent modifications (Prevents two people from modifying state simultaneously.)
    encrypt       = true                      # Enable server-side encryption for the state file in S3

   }
}

provider "aws" 
{
  region = "us-east-1"
}

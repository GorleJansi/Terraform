    bucket        = "roboshop1-remotestate-prod"   # Name of the S3 bucket where state file will be stored diff for each env
    key           = "tfvars-multi-env-demo"        # Path inside the S3 bucket for this specific Terraform state
    region        = "us-east-1"                    # AWS region where the S3 bucket exists
    use_lockfile  = true                           # Enables state locking to prevent concurrent modifications (Prevents two people from modifying state simultaneously.)
    encrypt       = true                           # Enable server-side encryption for the state file in S3

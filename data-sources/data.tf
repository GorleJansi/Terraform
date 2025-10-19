# Data-source--->Fetch an existing AMI from AWS account ; Unlike resource, they don’t create anything — they fetch existing data.

data "aws_ami" "joindevops" {
    owners      = ["973714476881"]    # The AWS account ID that owns the AMI
    most_recent = true                # Ensures Terraform picks the latest version if multiple images match

    # Filter 1: Match AMI by its 'name' field
    filter {
        name   = "name"
        values = ["RHEL-9-DevOps-Practice"]   # AMI name pattern to search for
    }

    # Filter 2: Match AMI with 'ebs' root volume type
    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    # Filter 3: Match AMI with 'hvm' virtualization
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

# ------------------------------------------------------------------------------
 # “Give me the latest AMI owned by account 973714476881 where:(Filters narrow down which AMI Terraform should select)
 # Name = RHEL-9-DevOps-Practice
 # Root device type = ebs
 # Virtualization = hvm”

# ------------------------------------------------------------------------------
# Output the ID of the AMI that was found

output "ami_id" {
    value = data.aws_ami.joindevops.id
}

 # When you run terraform apply, the console will show something like:
 # Outputs:
 # ami_id = "ami-0abc12345d6789ef0"

# ------------------------------------------------------------------------------
# Fetch details of an existing EC2 instance (does NOT create new one)

data "aws_instance" "mongodb" {
    instance_id = "i-0355f99cd46d41298"   # Existing EC2 instance ID
}

# Output to show the public IP of that instance
output "mongodb_info" {
    value = data.aws_instance.mongodb.public_ip
}
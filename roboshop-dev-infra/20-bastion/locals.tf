locals {
         # Retrieves the AMI ID from the data source "aws_ami.joindevops"
    ami_id = data.aws_ami.joindevops.id

         # Fetches the value of the SSM parameter named "bastion_sg_id"
    bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value

         # Gets the SSM parameter "public_subnet_ids" (public subnet IDs from the VPC module in comma-separated string from parameters.tf in 00-vpc)
         # Then splits it into a list and selects the first subnet ID ([0]).
         # This ensures the Bastion instance launches in the first public subnet.
    public_subnet_id = split("," , data.aws_ssm_parameter.public_subnet_ids.value)[0]

    common_tags = {
        Project     = var.project_name    # Name of the project (from variable)
        Environment = var.environment     # Environment (e.g., dev, staging, prod)
        Terraform   = "true"              # Marks resource as Terraform-managed
    }
}

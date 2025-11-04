# Create an SSM Parameter to store the VPC ID
resource "aws_ssm_parameter" "vpc_id" {
    # Name of the parameter in AWS Systems Manager Parameter Store
    # Using a pattern: /project_name/environment/vpc_id
  name  = "/${var.project_name}/${var.environment}/vpc_id"
    # Type of the parameter. "String" is for a single value
  type  = "String"
    # Value to store: the VPC ID output from the VPC module
  value = module.vpc.vpc_id
}
-----------------------------------------------------------------------------------------------
# Create an SSM Parameter to store all public subnet IDs as a comma-separated string

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_ids"
     # Type of the parameter. "StringList" is used to store multiple values separated by commas
  type  = "StringList"
     # Value: join all public subnet IDs from the VPC module into a comma-separated string
  value = join("," , module.vpc.public_subnet_ids)
}
-----------------------------------------------------------------------------------------------
# Create an SSM Parameter to store all private subnet IDs

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_ids"
  type  = "StringList"
  value = join("," , module.vpc.private_subnet_ids)
}
-----------------------------------------------------------------------------------------------
# Create an SSM Parameter to store database-specific subnet IDs

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/database_subnet_ids"
  type  = "StringList"
     # Value: join all database subnet IDs from the VPC module into a comma-separated string
  value = join("," , module.vpc.database_subnet_ids)
}



# AWS SSM Parameter Store allows parameters to be structured hierarchically using “paths”:
# You can assign IAM permissions at the path level.
# For example, allow a team to access only /myapp/prod/* without touching /myapp/dev/*.
# one module creates and stores vpc id using resource in ssm which can be used by  multiple Terraform modules to share the same VPC dynamically without hardcoding.
# ------------------------------------------------------------
# Fetch the VPC ID stored in AWS SSM Parameter Store
# ------------------------------------------------------------
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"   # This specifies the exact SSM parameter path to fetch. Example path: /roboshop/dev/vpc_id
      # It retrieves the VPC ID that was previously stored in Parameter Store (using resource created n stored)by another Terraform module .
      # The fetched value will be accessed using: data.aws_ssm_parameter.vpc_id.value
}


# one module creates and stores sg-id using resource in ssm which can be used by  multiple Terraform modules to share the sg-id  dynamically without hardcoding.
# ------------------------------------------------------------
# Fetch the Security Group ID for Backend ALB from SSM
# ------------------------------------------------------------
data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/backend_alb_sg_id"
      # Path example: /roboshop/dev/backend_alb_sg_id
      # The value can be used as: data.aws_ssm_parameter.backend_alb_sg_id.value
}


# ------------------------------------------------------------
# Fetch the Private Subnet IDs for backend ALB from SSM
# ------------------------------------------------------------
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnet_ids"
       # The value can be accessed as: data.aws_ssm_parameter.private_subnet_ids.value
       # (You might need to use split(",", value) if stored as a comma-separated string.)
}

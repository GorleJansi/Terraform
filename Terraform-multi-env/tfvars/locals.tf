  # Define a local variable "common_name" that uses variable ,interpolation "${}"
  # Example:
  #   var.project     = "roboshop"
  #   var.environment = "getfromCLI"/tfvars/env

locals {
  common_name = "${var.project}-${var.environment}"                    # common_name = "roboshop-getfromCLI"
  common_tags = {                    #  local map "common_tags" that stores key-value pairs.
    Project   = var.project
    Terraform = "true"
  }
}

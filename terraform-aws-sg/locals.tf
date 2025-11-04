locals {
  common_tags = {
        Project = var.project_name                                 #  roboshop
        Environment = var.environment                              #  dev
        Terraform = true
  }
  common_name_suffix = "${var.project_name}-${var.environment}"   # roboshop-dev
}
###########################################################
# VARIABLES — Define input values for reusable configuration
###########################################################

# Project name — used in tags and naming
variable "project" {
  default = "roboshop"
}

# Environment (ex: dev, prod, qa)     Terraform will prompt you for it at runtime when you run terraform plan or terraform apply.
# OR terraform apply -var="environment=dev" OR terraform apply -var-file=dev.tfvars OR export TF_VAR_environment=dev
variable "environment" {
  type = string
}

# AMI ID for EC2 instance
variable "ami_id" {
  type    = string
  default = "ami-09c813fb71547fc4f"  # Example Amazon Linux AMI
}

# Instance type (like t2.micro, t3.micro, etc.)
variable "instance_type" {
  type = string
}

# CIDR blocks for security group (IP ranges allowed)
variable "cidr" {
  type    = list
  default = ["0.0.0.0/0"]  # Allow from anywhere (not safe for prod)
}

# Ingress (inbound) rules — open all ports
variable "ingress_from_port" {
  default = 0
}

variable "ingress_to_port" {
  default = 0
}

# Egress (outbound) rules — open all ports
variable "egress_from_port" {
  default = 0
}

variable "egress_to_port" {
  default = 0
}

# Protocol for SG rules (-1 = all protocols)
variable "protocol" {
  type    = string
  default = "-1"
}

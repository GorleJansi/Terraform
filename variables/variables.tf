# ------------------------------
# Define the AMI ID variable
# ------------------------------
variable "ami_id" {
    type = string                              # Variable type: string (single text value)
    default = "ami-09c813fb71547fc4f"          # Default Amazon Machine Image (AMI) ID to use for EC2 instance
}

# ------------------------------
# Define the EC2 instance type
# ------------------------------
variable "instance_type" {
    type = string                              # Variable type: string
    default = "t3.micro"                       # Default instance type (small, low-cost instance)
}

# ------------------------------
# Define EC2 tags as a map
# ------------------------------
variable "ec2_tags" {
    type = map                                 # Variable type: map (key-value pairs)
    default = {                                # Default tag values applied to the EC2 instance
        Name        = "terraform-demo"         # Tag for the instance name (visible in AWS console)
        Terraform   = "true"                   # Tag to indicate the resource was created by Terraform
        Project     = "joindevops"             # Project name for identification
        Environment = "dev"                    # Environment type (e.g., dev, test, prod)
    }
}

# ------------------------------
# Define the Security Group name
# ------------------------------
variable "sg_name" {
    type = string                              # Variable type: string
    default = "allow-all"                      # Default name of the Security Group
    description = "Security Group Name to attach to EC2 instance"  # Description for clarity/documentation
}

# ------------------------------
# Define CIDR block list for Security Group rules
# ------------------------------
variable "cidr" {
    type = list                                # Variable type: list (a collection of values)
    default = ["0.0.0.0/0"]                    # Default allows access from all IP addresses (open to the world)
}

# ------------------------------
# Define ingress (inbound) port range
# ------------------------------
variable "ingress_from_port" {
    default = 0                                # Default 'from' port for ingress rules (0 = all ports)
}

variable "ingress_to_port" {
    default = 0                                # Default 'to' port for ingress rules (0 = all ports)
}

# ------------------------------
# Define egress (outbound) port range
# ------------------------------
variable "egress_from_port" {
    default = 0                                # Default 'from' port for egress rules (0 = all ports)
}
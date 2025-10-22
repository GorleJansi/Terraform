##############################################
# Terraform EC2 and Security Group Setup
# using Workspaces for multi-environment setup
##############################################

# -------------------------------
# EC2 INSTANCE RESOURCE
# -------------------------------
resource "aws_instance" "terraform" {
  # AMI (Amazon Machine Image) ID to use for the instance.
  # Passed dynamically using a variable.
  ami = var.ami_id

  # Instance type depends on the current workspace (dev, prod, etc.)
  # lookup() fetches the right instance type from a map variable.
  # Example: var.instance_type = { dev = "t3.micro", prod = "t3.large" }
  instance_type = lookup(var.instance_type, terraform.workspace)

  # Attach the security group defined below to this EC2 instance
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  # Tags help identify resources. 
  # merge() combines common tags from locals with instance-specific tags.
  tags = merge(
    local.common_tags, # Common tags like { Project = "roboshop", Terraform = "true" }
    {
      Name = "${local.common_name}-workspace" # Unique name like roboshop-dev-workspace
    }
  )
}

# -------------------------------
# SECURITY GROUP RESOURCE
# -------------------------------
resource "aws_security_group" "allow_all" {
  # Name for the security group (includes workspace info)
  name = "${local.common_name}-workspace"

  # ----------------------------
  # EGRESS (Outbound traffic rules)
  # ----------------------------
  egress {
    # Defines allowed outbound traffic
    from_port   = var.egress_from_port   # Starting port (e.g., 0)
    to_port     = var.egress_to_port     # Ending port (e.g., 65535)
    protocol    = "-1"                   # "-1" means all protocols are allowed
    cidr_blocks = var.cidr               # CIDR block list (e.g., ["0.0.0.0/0"])
  }

  # ----------------------------
  # INGRESS (Inbound traffic rules)
  # ----------------------------
  ingress {
    # Defines allowed inbound traffic
    from_port   = var.ingress_from_port  # e.g., 22 for SSH or 80 for HTTP
    to_port     = var.ingress_to_port    # Same as from_port if single port
    protocol    = var.protocol           # e.g., "tcp"
    cidr_blocks = var.cidr               # CIDR list allowed to connect
  }

  # ----------------------------
  # TAGS
  # ----------------------------
  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name}-workspace"
    }
  )
}


# -------------------------------
# HOW WORKSPACES WORK HERE
# -------------------------------
# terraform.workspace returns the active workspace name (dev, prod, qa, etc.)
# This helps dynamically choose configurations (AMI, instance type, naming, etc.)
#
# Example flow:
# terraform workspace new dev
# terraform apply -> creates "roboshop-dev" resources
#
# terraform workspace new prod
# terraform apply -> creates "roboshop-prod" resources
# -------------------------------


#############################################
# EC2 INSTANCE RESOURCE
#############################################

resource "aws_instance" "terraform" {
    ami = var.ami_id                                                 # This value is dynamically taken from a variable (var.ami_id)
    instance_type = var.instance_type                                # taken from a variable so it can be customized per environment
    vpc_security_group_ids = [aws_security_group.allow_all.id]       # aws_security_group.allow_all.id references the ID of the SG created later
    tags = merge(                                                    # 'merge()' combines comman tags from locals + specific tags defined here
      local.common_tags,                                             # These come from a locals block 
      {
        Name = "${local.common_name}-tfvars-multi-env"               # Create a Name tag dynamically using a local variable  # Example: "roboshop-dev-tfvars-multi-env"
      }
    )
}

#############################################
# SECURITY GROUP RESOURCE
#############################################

resource "aws_security_group" "allow_all" {
  name = "${local.common_name}-tfvars-multi-env"                       # Example: "roboshop-dev-tfvars-multi-env"

  #########################################
  # OUTBOUND RULES (Egress)

  egress {
    from_port = var.egress_from_port                                   # Starting port for outbound traffic in a range
    to_port = var.egress_to_port                                       # Ending port for outbound traffic in the range
    protocol = "-1"                                                    # Protocol type: "-1" means ALL protocols (TCP, UDP, ICMP)   
    cidr_blocks = var.cidr                                             # CIDR range allowed for outbound traffic # Example: ["0.0.0.0/0"] means all internet traffic is allowed 
  }

  #########################################
  # INBOUND RULES (Ingress)
 
  ingress {
    from_port = var.ingress_from_port
    to_port = var.ingress_to_port
    protocol = var.protocol                                            # Taken from variable (var.protocol) for flexibility
    cidr_blocks = var.cidr
  }

  #########################################
  # TAGS

  tags = merge(                                                        # Merge local common tags with an additional Name tag
    local.common_tags,                                                 # Defined in locals.tf for reusable project/environment tags
    {
      Name = "${local.common_name}-tfvars-multi-env"                   # Example: "roboshop-dev-tfvars-multi-env"
    }
  )
}

resource "aws_instance" "terraform" {
    ami = local.ami_id
    instance_type = local.instance_type
    vpc_security_group_ids = [aws_security_group.allow_all.id]
    tags = local.ec2_tags
}

resource "aws_security_group" "allow_all" {
  name   = "${local.common_name}-allow-all"    # roboshop-dev-allow-all      common_name = "${var.project}-${var.environment}" # roboshop-dev

  egress {
    from_port        = var.egress_from_port
    to_port          = var.egress_to_port
    protocol         = "-1" # -1 means all protocols
    cidr_blocks      = var.cidr
  }

  ingress {
    from_port        = var.ingress_from_port
    to_port          = var.ingress_to_port
    protocol         = var.protocol
    cidr_blocks      = var.cidr
  }

  tags = local.ec2_tags
}




1.✅ Variables provide inputs for your configuration.
2.✅ Terraform computes locals(centralize computed logic) after variables are known.
3.✅Terraform reads variables + locals to set : refernces in resources
4.✅Terraform plans what resources to create in AWS.
[Variable Defaults / Overrides] 
        │
        ▼
   [Locals Computed]  ← combines variables + constants
        │
        ▼
[Resource Configuration] 
   ├─ Security Group
   │    uses: locals + vars
   └─ EC2 Instance
        uses: locals + SG
        │
        ▼
[terraform apply]
        │
        ▼
[AWS Resources Created]
        │
        ▼
[State File Updated]

resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"                     # This is an inbound rule
  security_group_id = local.backend_alb_sg_id       # Applies to the backend ALB security group
  source_security_group_id = local.bastion_sg_id    # Allows traffic from the bastion SG
  from_port         = 80                            # Allow traffic from port 80 (HTTP)
  protocol          = "tcp"                         # Protocol is TCP
  to_port           = 80                            # Allow traffic to port 80
}

# Allows SSH connections from bastion to MongoDB instance.

resource "aws_security_group_rule" "mongodb_bastion" {
  type              = "ingress"                     # Inbound rule
  security_group_id = local.mongodb_sg_id           # Applies to MongoDB SG
  source_security_group_id = local.bastion_sg_id    # Allow traffic from bastion SG
  from_port         = 22                            # SSH port
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "mongodb_bastion" {
  type              = "ingress"
  security_group_id = local.mongodb_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "redis_bastion" {
  type              = "ingress"
  security_group_id = local.redis_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "rabbitmq_bastion" {
  type              = "ingress"
  security_group_id = local.rabbitmq_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

# Created as part of ticket 1234GDF
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  security_group_id = local.mysql_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "catalogue_bastion" {
  type              = "ingress"
  security_group_id = local.catalogue_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

# Allows catalogue backend instance to connect to MongoDB on port 27017.
resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  security_group_id = local.mongodb_sg_id
  source_security_group_id = local.catalogue_sg_id
  from_port         = 27017
  protocol          = "tcp"
  to_port           = 27017
}

# Allows backend ALB to send traffic to catalogue service on port 8080.
resource "aws_security_group_rule" "catalogue_backend_alb" {
  type              = "ingress"
  security_group_id = local.catalogue_sg_id
  source_security_group_id = local.backend_alb_sg_id
  from_port         = 8080
  protocol          = "tcp"
  to_port           = 8080
}
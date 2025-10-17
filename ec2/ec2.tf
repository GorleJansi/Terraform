# -----------------------------
# EC2 Instance Configuration
# -----------------------------
resource "aws_instance" "terraform" {     # Define a resource of type 'aws_instance' and give it a logical name 'terraform'
    ami = "ami-09c813fb71547fc4f"         # AMI (Amazon Machine Image) ID used to launch the instance — defines OS/image template
    instance_type = "t3.micro"            # Instance type — defines hardware (CPU, memory). Here, it's a small free-tier eligible instance.

    # Attach Security Group
    vpc_security_group_ids = [aws_security_group.allow_all.id]  # Associate this EC2 instance with the Security Group defined below ('allow_all')

    # Tags are used for identifying and organizing AWS resources
    tags = {
        Name = "terraform-1"              # Tag 'Name' — appears in AWS Console to identify the instance
        Terraform = "true"                # Custom tag showing that this instance was created via Terraform
    }
}

# -----------------------------
# Security Group Configuration
# -----------------------------
resource "aws_security_group" "allow_all" {   # Define a Security Group named 'allow_all'
  name   = "allow-all"                        # Name of the security group (visible in AWS Console)

  # -------------- Outbound Rules --------------
  egress {                                    # Egress = outbound traffic (from instance → outside)
    from_port        = 0                      # Starting port number (0 means all ports)
    to_port          = 0                      # Ending port number (0 means all ports)
    protocol         = "-1"                   # -1 means all protocols (TCP, UDP, ICMP, etc.)
    cidr_blocks      = ["0.0.0.0/0"]          # Allows outbound traffic to any IP on the Internet
  }

  # -------------- Inbound Rules --------------
  ingress {                                   # Ingress = inbound traffic (from outside → instance)
    from_port        = 0                      # Starting port number (0 means all ports)
    to_port          = 0                      # Ending port number (0 means all ports)
    protocol         = "-1"                   # -1 means all protocols
    cidr_blocks      = ["0.0.0.0/0"]          # Allows inbound traffic from any IP address (open to the world)
  }

  # Tags help to identify the Security Group
  tags = {
    Name = "allow-all"                        # Tag name to label the SG as 'allow-all'
  }
}

resource "aws_instance" "terraform" {
    ami = "ami-09c813fb71547fc4f"

    # Choose instance type dynamically based on environment variable:
    # - If environment = "dev", use small instance (t3.micro)
    # - Otherwise, use larger instance (t3.medium)
    instance_type = var.environment == "dev" ? "t3.micro" : "t3.medium"
    
    vpc_security_group_ids = [aws_security_group.allow_all.id]
    tags = {
        Name = "terraform"
        Terraform = "true"
    }
}

resource "aws_security_group" "allow_all" {
  name   = "allow-all"

  egress {
    from_port        = 0 # from port 0 to to port 0 means all ports
    to_port          = 0 
    protocol         = "-1" # -1 means all protocols
    cidr_blocks      = ["0.0.0.0/0"] # internet
  }

  ingress {
    from_port        = 0 # from port 0 to to port 0 means all ports
    to_port          = 0 
    protocol         = "-1" # -1 means all protocols
    cidr_blocks      = ["0.0.0.0/0"] # internet
  }

  tags = {
    Name = "allow-all"
  }

}
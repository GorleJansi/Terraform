
resource "aws_instance" "terraform" {    # Define an AWS EC2 instance resource named "terraform"

                    # count = 10       # Optional: You could manually specify how many instances to create (commented out here)
                    # Dynamically create instances based on the length of a variable list (var.instances)
                    # Example: if var.instances = ["web", "db", "app"], Terraform creates 3 instances
                    
    count = length(var.instances)
    ami = "ami-09c813fb71547fc4f"
    instance_type = "t3.micro"

                    # Attach the EC2 instance to the given Security Group
                    # Uses the Security Group resource created elsewhere in the config (aws_security_group.allow_all)
    vpc_security_group_ids = [aws_security_group.allow_all.id]
            
    tags = {        # Add tags to each instance for identification and management
                    # Assign a unique Name tag using the instance name from the var.instances list
                    # count.index gives the current instance’s index in the list
        Name = var.instances[count.index]
                    # Project name tag for organizational or billing purposes
        Project = "roboshop"
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
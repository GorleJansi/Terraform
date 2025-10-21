##########################################
# Security Group: Allow All Traffic
##########################################
resource "aws_security_group" "allow_all" {
  # Name of the security group
  name   = "allow-all"

  # Egress rules: outbound traffic
  egress {
    from_port   = 0       # Start port (0 means all ports)
    to_port     = 0       # End port (0 means all ports)
    protocol    = "-1"    # All protocols (-1)
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to internet
  }

  # Ingress rules: inbound traffic
  ingress {
    from_port   = 0       # Start port
    to_port     = 0       # End port
    protocol    = "-1"    # All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from internet
  }

  # Tags for identifying the resource
  tags = {
    Name = "allow-all"
  }
}

##########################################
# EC2 Instance with Provisioners
##########################################
resource "aws_instance" "terraform" {
  # AMI ID for the instance (Amazon Linux / RHEL / Ubuntu)
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t3.micro"   # EC2 instance type

  # Associate the instance with the above security group
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  # Tags for the instance
  tags = {
    Name      = "terraform-1"
    Terraform = "true"
  }

  #################################################
  # Local Provisioner: Run command on local machine
  #################################################
  provisioner "local-exec" {
    # Write private IP of the instance to an inventory file
    command = "echo ${self.private_ip} > inventory"

    # Continue even if this command fails
    on_failure = continue
  }

  provisioner "local-exec" {
    # Print message locally when instance is destroyed
    command = "echo Instance is destroyed"
    when    = destroy  # Run this only during destroy
  }

  #################################################
  # Connection Block: Needed for remote provisioners
  #################################################
  connection {
    type     = "ssh"           # SSH connection
    user     = "ec2-user"      # SSH username
    password = "DevOps321"     # Password for SSH (not recommended in prod)
    host     = self.public_ip  # Public IP of the EC2 instance
  }

  #################################################
  # Remote Provisioners: Run commands on the EC2
  #################################################
  provisioner "remote-exec" {
    inline = [
      "sudo dnf install nginx -y",   # Install Nginx
      "sudo systemctl start nginx"   # Start Nginx service
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl stop nginx",                    # Stop Nginx
      "echo 'successfully stopped nginx server' "    # Print message
    ]
    when = destroy  # Run only when destroying the instance
  }
}

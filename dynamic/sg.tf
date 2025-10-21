
resource "aws_security_group" "roboshop_instance" {    # Define a new AWS Security Group resource called "roboshop_instance"
  name   = "roboshop-strict-sg"                        # Name of the security group in AWS

  egress {                                        # Define outbound traffic rules (egress)
    from_port   = 0                               # Start port in the range 0
    to_port     = 0                               # End port in the range 0 if from_port=to_port only that one specific port is allowed.
    protocol    = "-1"                            # -1 means all protocols (TCP, UDP, ICMP etc.)
    cidr_blocks = ["0.0.0.0/0"]                   # Allow traffic to all IPs on the internet
  }
  
  dynamic "ingress" {                           # Define inbound-traffic-rules(ingress) dynamically based on a variable
    for_each = toset(var.ingress_ports)         # Loop through each port in the "ingress_ports" variable
    content {
        from_port   = ingress.value       # reference the current item using BLOCK_LABEL.value.(inbound start port)
        to_port     = ingress.value       # reference the current item using BLOCK_LABEL.value.
        protocol    = "tcp"               # Only allow TCP protocol
        cidr_blocks = ["0.0.0.0/0"]      # Allow traffic from all IPs on the internet
    }
  }

  # Add tags to the security group
  tags = {
    Name = "roboshop-strict-sg"          # Key "Name" with value for identification
  }

}




# Sets and lists only have .value in a dynamic block loop.
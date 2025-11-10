# =========================================================
# Create a single EC2 instance for the Catalogue service
# =========================================================
resource "aws_instance" "catalogue" {
    ami = local.ami_id                    # AMI ID to use for the instance
    instance_type = "t3.micro"            # Instance type
    vpc_security_group_ids = [local.catalogue_sg_id]  # Security group for this instance
    subnet_id = local.private_subnet_id   # Subnet where instance will be deployed
    
    # Tags help identify resources in AWS
    tags = merge (
        local.common_tags,                # Common tags for all resources (like project, environment)
        {
            Name = "${local.common_name_suffix}-catalogue"  # Specific name for this instance
        }
    )
}

# =========================================================
# Connect and configure EC2 instance via Terraform
# =========================================================
resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id           # Re-run this provisioner if instance ID changes
  ]
  
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"             
    host     = aws_instance.catalogue.private_ip  # Connect via private IP
  }

  # Copy local script to EC2 instance
  provisioner "file" {
    source = "catalogue.sh"
    destination = "/tmp/catalogue.sh"
  }

  # Execute script remotely on the EC2 instance
  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/catalogue.sh",   # Make script executable
        "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"  # Run script with arguments
    ]
  }
}

# =========================================================
# Stop the instance to create an clean AMI (image)  . AMI cannot be created while the instance is running.
# =========================================================
resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on = [terraform_data.catalogue]   # Ensure provisioning completes first
}

# =========================================================
# Create an AMI from the configured instance
# Creates a reusable Amazon Machine Image (AMI) from the configured EC2 instance. This AMI can be used in auto-scaling groups later.
# =========================================================
resource "aws_ami_from_instance" "catalogue" {
  name               = "${local.common_name_suffix}-catalogue-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [aws_ec2_instance_state.catalogue]  # Ensure instance is stopped first

  tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-catalogue-ami"
        }
  )
}

# =========================================================
# Create a Target Group for Load Balancer
# =========================================================
resource "aws_lb_target_group" "catalogue" {  
  name     = "${local.common_name_suffix}-catalogue"  # Example: if local.common_name_suffix = "roboshop-dev", name = "roboshop-dev-catalogue"
  port     = 8080                   # Your application listens on port 8080 The port on which targets receive traffic from the load balancer
  protocol = "HTTP"                 # The protocol used by the load balancer to communicate with targets
  vpc_id   = local.vpc_id           # The VPC where the target group is created. All targets must be in this VPC.
  deregistration_delay = 60         # Time in seconds to wait before deregistering a target after it is removed from the target group.

  health_check {
    healthy_threshold = 2           # Number of consecutive successful responses required before considering a target healthy
    interval = 10                   # Interval in seconds between health checks
    matcher = "200-299"             # HTTP status codes to consider as healthy
    path = "/health"                # Path on the target that the load balancer will query for health checks
    port = 8080                     # Port to use for health checks. Can be same as the target port.
    protocol = "HTTP"               # Protocol used for health check requests
    timeout = 2                     # Timeout in seconds for each health check request
    unhealthy_threshold = 2         # Number of consecutive failed health checks before considering a target unhealthy
  }
}

# =========================================================
# Launch Template for Auto Scaling Group
# Launch Templates are reusable configurations for EC2 instances, often used with Auto Scaling Groups.
# =========================================================
resource "aws_launch_template" "catalogue" {  

  name = "${local.common_name_suffix}-catalogue"     # Name of the launch template.
  image_id = aws_ami_from_instance.catalogue.id      # Specifies the AMI (Amazon Machine Image) ID to use for instances launched with this template. Here, it references an AMI created from an existing instance ('catalogue').
  instance_initiated_shutdown_behavior = "terminate" # 'terminate' means the EC2 instance will be deleted when shut down.
  instance_type = "t3.micro"  
  vpc_security_group_ids = [local.catalogue_sg_id]   # Assign security groups to the instance.
  tag_specifications {                               # Tag specifications allow tagging at resource creation
    resource_type = "instance"  
    tags = merge(local.common_tags, { Name = "${local.common_name_suffix}-catalogue" })  
  }

  tag_specifications {
    resource_type = "volume"  
    # Specifies tags to apply to EBS volumes created with this instance.
    tags = merge(local.common_tags, { Name = "${local.common_name_suffix}-catalogue" })  
  }

  tags = merge(local.common_tags, { Name = "${local.common_name_suffix}-catalogue" })  
  # Tags applied directly to the launch template itself.

}

# =========================================================
# Auto Scaling Group for Catalogue
# =========================================================
resource "aws_autoscaling_group" "catalogue" {
  name = "${local.common_name_suffix}-catalogue"
  max_size = 10                           # Maximum number of EC2 instances the ASG can scale up to
  min_size = 1                            # Minimum number of EC2 instances the ASG should maintain
  desired_capacity = 1                    # Desired number of instances to start with
  health_check_type = "ELB"               # Type of health check for instances in the ASG: "ELB" means it uses the Load Balancer health check
  health_check_grace_period = 100         # Grace period (in seconds) before the health check starts failing a new instance
  force_delete = false                    # Whether to force delete the ASG even if instances are running
  
  launch_template {
    id = aws_launch_template.catalogue.id    # Reference to the launch template ID created elsewhere in Terraform
    version = aws_launch_template.catalogue.latest_version
  }
  vpc_zone_identifier = local.private_subnet_ids             # Subnets in which the ASG will launch EC2 instances (private subnets in this case)
  target_group_arns = [aws_lb_target_group.catalogue.arn]    # Attach the ASG to a Load Balancer Target Group(Load Balancer can send traffic toevery EC2 instance launched by the ASG automatically as it becomes part of that Target Group.)
  
  dynamic "tag" {   # A dynamic block lets you loop over a map or list and create multiple tag blocks automatically.For each key-value pair, Terraform creates a separate tag {} block.
    for_each = merge(local.common_tags, { Name = "${local.common_name_suffix}-catalogue" })   # Iterates over all tags from local.common_tags plus a custom Name tag
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true    # Ensures this tag is applied to EC2 instances launched by the ASG
    }
  }

  timeouts {    # Timeouts block defines how long Terraform waits for operations
    # Timeout for deleting the ASG (e.g., if Terraform destroys this resource)
    delete = "15m"
  }
}

# =========================================================
# Auto Scaling Policy
# Keep the ASG’s CPU around 75%. Add servers if CPU is too high, remove servers if CPU is too low.
# =========================================================
resource "aws_autoscaling_policy" "example" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name     # Attach this scaling policy to an existing Auto Scaling Group
  name                   = "${local.common_name_suffix}-catalogue"  # name of policy
  policy_type            = "TargetTrackingScaling"                  # Type of scaling policy- Automatically adjusts capacity based on a target metric
  
  target_tracking_configuration {  
    predefined_metric_specification {                               # Use a predefined metric to track
      predefined_metric_type = "ASGAverageCPUUtilization"           # Metric to track – here, average CPU utilization of the ASG
    }
    target_value = 75.0                                             # The ASG will try to maintain 75% average CPU utilization
  }
}

# =========================================================
# RULE - ATTACH TO LISTENER 
# ALB Listener Rule for the "catalogue" service
# This resource creates a rule for the ALB listener.
# The rule forwards incoming requests to the target group based on a host header condition.
# =========================================================
resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn   # ARN of the ALB listener to which this rule will be attached
  priority     = 10                               # Lower numbers have higher precedence. If multiple rules match, the one with the lowest priority is applied.
  action {                                        # Action block defines what happens when a request matches the condition
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn       # ARN of the target group to forward requests to. requests are forwarded to the "catalogue" target group.
  }
  condition {                                     # Condition block defines the criteria that must be met for the action to trigger
    host_header {                                 # Host header condition: this rule triggers if the request's host header matches one of the specified values
      values = ["catalogue.backend-alb-${var.environment}.${var.domain_name}"]     # Values is a list of hostnames. The rule will match if the request's "Host" header matches this value.
      # This dynamically constructs the hostname based on environment and domain name variables
      # Example: "catalogue.backend-alb.dev.example.com"
    }
  }
}

# =========================================================
# Cleanup - Terminate original EC2 instance
# =========================================================
resource "terraform_data" "catalogue_local" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  
  depends_on = [aws_autoscaling_policy.catalogue]

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
  }
}

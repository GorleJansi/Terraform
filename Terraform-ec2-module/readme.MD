# AWS EC2 Instance

This module creates EC2 instance.

"A Terraform module is analogous to a function in programming: it accepts input variables, performs defined operations, and produces outputs that can be consumed by the calling module or root configuration."

### Inputs

* ami_id - (Optional) Defaults to ```ami-09c813fb71547fc4f```
* instance_type - (Required) User must supply instance type either t3.micro or t3.small or t3.medium
* sg_ids - (Required) user must supply a list of security group IDS to attach Ec2 instance
* tags - (Optional) user can supply the tags attach to EC2 instance

### Outputs

* public_ip - Public IP of the instance created(taken from attributes of instance created aws_instance.this.public_ip)
* private_ip - Private IP of the instance created(taken from attributes of instance created aws_instance.this.private_ip)
* instance_id - Instance ID created
# Defining a module block ;A module is a reusable set of Terraform resources — like a template.

module "EC2" {
  # The 'source' tells Terraform where to find the module code.Here it's in a local path, one directory up (../), inside "terraform-aws-instance".
  
  source = "../Terraform-ec2-module"
  ami_id = var.ami_id
  sg_ids = var.sg_ids
  instance_type = var.instance_type
  tags = var.tags
}

output "pub_ip" {
  value=module.EC2.public_ip
}

output "priv_ip" {
  value=module.EC2.private_ip
}
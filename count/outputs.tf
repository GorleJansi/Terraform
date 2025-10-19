output "instances_output" {                       # Define an output block named "instances_output"

  value = aws_instance.terraform                  # 'value' specifies what data to display after Terraform apply.Here, it outputs all the attributes of the 'aws_instance.terraform' resource.
}

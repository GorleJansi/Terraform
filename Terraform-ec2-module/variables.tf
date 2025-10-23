
variable "ami_id" {
  type        = string
  default = "ami-09c813fb71547fc4f"         # default value can be overridden when using modules
  description = "this is the AMI used for creating EC2 instance"
}

variable "instance_type" {
  type = string
  description = "Instance type used for creating EC2 instance"

  # Validation block — this ensures that the input value meets certain rules.  contains(list, inputvalue)
  validation {           
    condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
    error_message = "Please select either t3 micro or small or medium"
  }
}

# mandatory  Must give list values to this var else error
variable "sg_ids" {
  type = list      
  #no default value must give in .tf vars,-vars=" " cli,env TF_VARS,prompt 
}

# optional  The default value is an empty map {} If the user doesn’t pass any tags, Terraform will still work.
variable "tags" {
  type = map
  default = {}
}



# default values which can be overridden or used as it is in module users
variable "ingress_ports" {
    default = [80,22,8080,22017, 6379]     # Replace/add/remove ports here   # List of ports allowed inbound
}


 # to override values from console ,No need to change .tf files.
 # terraform apply -var 'ingress_ports=[80,22,443,3306]'


 # Every time you change ingress_ports, Terraform will try to update the security-group-rules according to the new list.
 # Removing a port will delete the rule, adding a port will create a new rule.
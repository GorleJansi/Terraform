# Creates a Route53 DNS record for each EC2 instance defined in var.instances

resource "aws_route53_record" "roboshop" {

  count = length(var.instances)                                   # Creates multiple DNS records – one for each instance name in the 'instances' variable

  zone_id = "${var.zone_id}"                                      # The Route53 Hosted Zone ID where these records will be created

  name = "${var.instances[count.index]}.${var.domain_name}"       # DNS record name → combines instance name + domain name    # Example: mongodb.jansi1.site

  type = "A"                                                      # Type of DNS record – "A" record maps a name to an IP address
        
  ttl = 1

  records = [aws_instance.terraform[count.index].private_ip]       # The IP address of the EC2 instance to associate with this record ,Takes the private IP from the aws_instance resource at the same index

  allow_overwrite = true                                           # Allows Terraform to overwrite an existing DNS record with the same name
}




# ❌ Wrong (plain string, no interpolation)
# name = "var.instances[count.index].var.domain_name"  ->vars not substitued

# ✅ Correct (Terraform interpolation syntax)
# name = "${var.instances[count.index]}.${var.domain_name}"
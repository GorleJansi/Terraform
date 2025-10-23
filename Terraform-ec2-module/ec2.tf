resource "aws_instance" "this" {
    ami = var.ami_id                    # mandatory
    instance_type = var.instance_type   # mandatory
    vpc_security_group_ids = var.sg_ids # mandatory
    tags = var.tags                     # optional
}




# module is like function it takes input and give outputs which must be taken by called modules
# when creating module make it mostly parameterized 
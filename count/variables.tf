variable "instances" {
    default = [ "mongodb", "redis", "mysql", "rabbitmq", "catalogue", "user", "cart", "shipping", "payment", "frontend" ]
}

variable "zone_id" {
    default = "Z03265102RMME1CTCUN7"
}

variable "domain_name" {
    default = "jansi1.site"
}
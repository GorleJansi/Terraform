variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "sg_name" {
  type        = string        # mandatory
}

variable "sg_description" {
  type        = string
  default = ""                # optional
}

variable "vpc_id" {
    type = string
}

variable "sg_tags" {
    type = map
    default = {}
}
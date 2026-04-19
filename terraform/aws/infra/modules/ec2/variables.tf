variable "ami" {}
variable "instance_type" {}
variable "subnet_id" {}

variable "sg_ids" {
  type = list(string)
}

variable "public_ip" {
  type    = bool
  default = true
}

variable "user_data" {}
variable "name" {}
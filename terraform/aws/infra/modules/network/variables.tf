variable "vpc_id" {
  description = "VPC ID"
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "name" {
  description = "Name prefix"
}
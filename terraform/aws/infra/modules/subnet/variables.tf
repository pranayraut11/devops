variable "vpc_id" {
  description = "VPC ID"
}

variable "cidr_block" {
  description = "CIDR block for subnet"
}

variable "availability_zone" {
  description = "AZ for subnet"
}

variable "map_public_ip" {
  description = "Assign public IP"
  type        = bool
  default     = true
}

variable "name" {
  description = "Subnet name"
}
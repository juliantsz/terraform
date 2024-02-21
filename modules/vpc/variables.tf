variable "environment" {
  description = "Environment used for the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR range for the VPC"
  type        = string
}

variable "public_subnets_cidrs" {
  description = "CidrBlock for public subnet 01 within the VPC"
  type        = list(string)
}

variable "private_subnets_cidrs" {
  description = "CidrBlock for private subnet 01 within the VPC"
  type        = list(string)
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
}
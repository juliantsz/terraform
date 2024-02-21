variable "environment" {
  type = string
  default = "dev"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidrs" {
  type        = list(string)
  default     = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
}

variable "private_subnets_cidrs" {
  type        = list(string)
  default     = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]
}

variable "azs" {
 type        = list(string)
 default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
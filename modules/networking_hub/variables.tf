variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
}

variable "hub_vpc_cidr_block" {
  description = "The CIDR block for the Hub VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "hub_subnet_cidrs" {
  description = "A map of CIDR blocks for the Hub VPC subnets, keyed by availability zone suffix (e.g., 'a', 'b')."
  type        = map(string)
  default = {
    "a" = "10.0.1.0/24"
    "b" = "10.0.2.0/24"
  }
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

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

variable "enable_vpc_flow_logs" {
  description = "Enable VPC Flow Logs for the Hub VPC."
  type        = bool
  default     = true
}

variable "flow_logs_s3_bucket_name" {
  description = "S3 bucket name for VPC Flow Logs. If empty, a new one will be created."
  type        = string
  default     = ""
}

variable "enable_route53_resolver" {
  description = "Enable Route 53 Resolver for centralized DNS."
  type        = bool
  default     = false
}

variable "route53_resolver_inbound_ip_addresses" {
  description = "List of IP addresses for Route 53 Resolver inbound endpoints."
  type        = list(string)
  default     = []
}

variable "route53_resolver_outbound_ip_addresses" {
  description = "List of IP addresses for Route 53 Resolver outbound endpoints."
  type        = list(string)
  default     = []
}

variable "route53_resolver_target_ips" {
  description = "Map of DNS forward rules for Route 53 Resolver outbound endpoints."
  type = map(object({
    domain_name = string
    target_ips  = list(string)
  }))
  default = {}
}
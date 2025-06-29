variable "customer_gateway_bgp_asn" {
  description = "The BGP ASN of the customer gateway."
  type        = number
}

variable "customer_gateway_ip_address" {
  description = "The public IP address of the customer gateway."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the VPN Gateway will be attached (Hub VPC)."
  type        = string
}

variable "transit_gateway_id" {
  description = "The ID of the Transit Gateway to attach the VPN connection to."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

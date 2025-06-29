variable "name" {
  description = "The name of the Direct Connect connection."
  type        = string
}

variable "location" {
  description = "The Direct Connect location where the connection will be terminated."
  type        = string
}

variable "bandwidth" {
  description = "The bandwidth of the connection (e.g., 1Gbps, 10Gbps)."
  type        = string
}

variable "vlan" {
  description = "The VLAN ID for the virtual interface."
  type        = number
}

variable "bgp_asn" {
  description = "The BGP ASN (Autonomous System Number) of your network."
  type        = number
}

variable "bgp_auth_key" {
  description = "The BGP authentication key (MD5) for the BGP session."
  type        = string
  sensitive   = true
}

variable "amazon_side_asn" {
  description = "The Amazon-side BGP ASN for the virtual interface."
  type        = number
}

variable "transit_gateway_id" {
  description = "The ID of the Transit Gateway to associate with."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

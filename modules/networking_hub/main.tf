resource "aws_ec2_transit_gateway" "main" {
  description = "Main Transit Gateway for the Landing Zone"
  tags        = var.tags
}

resource "aws_vpc" "hub_vpc" {
  cidr_block           = var.hub_vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

resource "aws_subnet" "hub_subnets" {
  for_each = var.hub_subnet_cidrs

  vpc_id            = aws_vpc.hub_vpc.id
  cidr_block        = each.value
  availability_zone = "${var.aws_region}${each.key}"
  tags              = var.tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "hub_vpc_attachment" {
  vpc_id              = aws_vpc.hub_vpc.id
  transit_gateway_id  = aws_ec2_transit_gateway.main.id
  subnet_ids          = [for s in aws_subnet.hub_subnets : s.id]
  dns_support         = "enable"
  ipv6_support        = "disable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
  tags                = var.tags
}

# VPC Flow Logs
resource "aws_s3_bucket" "flow_logs_bucket" {
  count = var.enable_vpc_flow_logs && var.flow_logs_s3_bucket_name == "" ? 1 : 0

  bucket = "${var.hub_vpc_cidr_block}-flow-logs-${var.aws_region}"
  acl    = "private"
  tags   = var.tags
}

resource "aws_s3_bucket_policy" "flow_logs_bucket_policy" {
  count = var.enable_vpc_flow_logs && var.flow_logs_s3_bucket_name == "" ? 1 : 0

  bucket = aws_s3_bucket.flow_logs_bucket[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSLogDeliveryWrite"
        Effect    = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action    = "s3:PutObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.flow_logs_bucket[0].id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
      },
      {
        Sid       = "AWSLogDeliveryCheck"
        Effect    = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action    = "s3:GetBucketAcl"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.flow_logs_bucket[0].id}"
      }
    ]
  })
}

resource "aws_vpc_flow_log" "main" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  log_destination_type = "s3"
  log_destination      = var.flow_logs_s3_bucket_name != "" ? "arn:aws:s3:::${var.flow_logs_s3_bucket_name}" : aws_s3_bucket.flow_logs_bucket[0].arn
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.hub_vpc.id
  tags                 = var.tags
}

data "aws_caller_identity" "current" {}

# Route 53 Resolver
resource "aws_route53_resolver_endpoint" "inbound" {
  count = var.enable_route53_resolver && length(var.route53_resolver_inbound_ip_addresses) > 0 ? 1 : 0

  name      = "${var.hub_vpc_cidr_block}-inbound-resolver"
  direction = "INBOUND"
  security_group_ids = [aws_security_group.resolver_sg.id]
  ip_address {
    for_each = toset(var.route53_resolver_inbound_ip_addresses)
    subnet_id = aws_subnet.hub_subnets[each.key].id # Assuming subnets are named by AZ suffix
    ip_address = each.value
  }
  tags      = var.tags
}

resource "aws_route53_resolver_endpoint" "outbound" {
  count = var.enable_route53_resolver && length(var.route53_resolver_outbound_ip_addresses) > 0 ? 1 : 0

  name      = "${var.hub_vpc_cidr_block}-outbound-resolver"
  direction = "OUTBOUND"
  security_group_ids = [aws_security_group.resolver_sg.id]
  ip_address {
    for_each = toset(var.route53_resolver_outbound_ip_addresses)
    subnet_id = aws_subnet.hub_subnets[each.key].id # Assuming subnets are named by AZ suffix
    ip_address = each.value
  }
  tags      = var.tags
}

resource "aws_security_group" "resolver_sg" {
  count = var.enable_route53_resolver ? 1 : 0

  name        = "${var.hub_vpc_cidr_block}-resolver-sg"
  description = "Security group for Route 53 Resolver endpoints"
  vpc_id      = aws_vpc.hub_vpc.id

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.hub_vpc_cidr_block] # Allow DNS queries from within Hub VPC
  }
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.hub_vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags        = var.tags
}

resource "aws_route53_resolver_rule" "main" {
  for_each = var.route53_resolver_target_ips

  domain_name          = each.value.domain_name
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound[0].id

  dynamic "target_ip" {
    for_each = each.value.target_ips
    content {
      ip = target_ip.value
    }
  }
  tags                 = var.tags
}
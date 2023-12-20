// ---
// Create the VPC
// ---

resource "aws_vpc" "private_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.name
  }
}

// ---
// Create the Private Subnets
// ---

resource "aws_subnet" "private_subnet" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = aws_vpc.private_vpc.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
   Name = "${var.name}-subnet-${count.index}"
  }
}

// ---
// Create the Route Table
// ---

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.private_vpc.id
}

// ---
// Create the Route Table Associations
// ---

resource "aws_route_table_association" "subnet_association" {
  count          = length(var.subnet_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

// ---
// Create the NACL
// ---

resource "aws_network_acl" "private_vpc_nacl" {
  vpc_id = aws_vpc.private_vpc.id
  tags = {
    Name = "${var.name}-NACL"
  }
}

// ---
// NACL Rule to Allow All Inbound and Outbound Traffic within the VPC
// ---

resource "aws_network_acl_rule" "allow_inbound_outbound_within_vpc" {
  network_acl_id = aws_network_acl.private_vpc_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.allow_inbound_cidr
  from_port      = 0
  to_port        = 0
}

// Duplicate the rule for outbound traffic
resource "aws_network_acl_rule" "allow_outbound_within_vpc" {
  network_acl_id = aws_network_acl.private_vpc_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.allow_outbound_cidr
  from_port      = 0
  to_port        = 0
}

// ---
// Associate NACL with the Subnets
// ---

resource "aws_network_acl_association" "nacl_association" {
  count          = length(aws_subnet.private_subnet.*.id)
  network_acl_id = aws_network_acl.private_vpc_nacl.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

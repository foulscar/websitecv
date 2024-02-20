// ---
// Create a Private VPC for the VPC Endpoint
// ---

module "private_vpc" {
  source              = "../../modules/aws/vpc/private/v1"
  name                = "${var.stage}-tf-websitecv-private"
  vpc_cidr            = "10.0.0.0/16"
  allow_inbound_cidr  = "10.0.0.0/16"
  allow_outbound_cidr = "10.0.0.0/16"
  subnet_cidrs        = ["10.0.0.0/24", "10.0.1.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
}

// ---
// Create the VPC Endpoint for the Private API
// ---

resource "aws_vpc_endpoint" "private_api_endpoint" {
  vpc_id              = module.private_vpc.vpc_id
  service_name        = "com.amazonaws.us-east-1.execute-api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.private_sg.id]
  subnet_ids          = module.private_vpc.subnet_ids
}

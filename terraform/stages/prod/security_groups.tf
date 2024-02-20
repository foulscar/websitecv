// ---
// Create a Private Security Group
// ---

resource "aws_security_group" "private_sg" {
  vpc_id = module.private_vpc.vpc_id

  # Ingress rule to allow traffic from 10.0.0.0/16
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic to 10.0.0.0/16
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-igw"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-rt"
  }
}

# Route to Internet
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Subnet A
resource "aws_route_table_association" "subnet_a" {
  subnet_id      = var.subnet_ids[0]
  route_table_id = aws_route_table.public.id
}

# Associate Subnet B
resource "aws_route_table_association" "subnet_b" {
  subnet_id      = var.subnet_ids[1]
  route_table_id = aws_route_table.public.id
}
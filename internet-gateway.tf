resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    name = "${var.vpc_name}-internet-gateway"
  }
}
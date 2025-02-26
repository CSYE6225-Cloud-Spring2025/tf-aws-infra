resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr_range
  tags = {
    Name = var.vpc_name
  }
}
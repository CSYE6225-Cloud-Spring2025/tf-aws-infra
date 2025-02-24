resource "aws_subnet" "public_subnet" {
  count             = 3
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = var.public_cidr_range[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.test_vpc.bad
  cidr_block        = var.private_cidr_range[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  }
}

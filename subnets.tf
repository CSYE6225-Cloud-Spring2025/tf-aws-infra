resource "aws_subnet" "public_subnet" {
  count             = 3
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = var.public_cidr_range[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = var.private_cidr_range[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet[1].id]
  tags = {
    Name = "RDS subnet group"
  }
}
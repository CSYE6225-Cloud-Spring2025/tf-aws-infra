resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    name = "${var.vpc_name}-private-route-table"
  }
}

resource "aws_route_table_association" "private_routes" {
  count          = 3
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
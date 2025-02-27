resource "aws_instance" "web_application" {
  ami                         = var.ami_id
  instance_type               = var.ec2_instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet[1].id
  vpc_security_group_ids      = [aws_security_group.webapp_security_group.id]

  disable_api_termination = false
  root_block_device {
    delete_on_termination = true
    volume_size           = 25
    volume_type           = "gp2"
  }

  tags = {
    Name = "webapp-server"
  }
}
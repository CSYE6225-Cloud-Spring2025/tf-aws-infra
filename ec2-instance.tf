resource "aws_key_pair" "aws_ec2_key" {
  key_name   = var.ec2_key_name
  public_key = file(var.ec2_key_file)
}

resource "aws_instance" "web_application" {
  ami                         = var.ami_id
  instance_type               = var.ec2_instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet[1].id
  vpc_security_group_ids      = [aws_security_group.webapp_security_group.id]

  key_name             = aws_key_pair.aws_ec2_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data            = <<-EOF
    #!/bin/bash
    
    sudo touch /opt/csye6225/webapp/.env
    sudo chmod 666 /opt/csye6225/webapp/.env
    {
      echo "DB_HOST=${aws_db_instance.rds_mysql.address}"
      echo "DB_USER=${var.rds_username}"
      echo "DB_PASSWORD=${local.rds_password}"
      echo "DB_NAME=${var.rds_db_name}"
      echo "PORT=${var.webapp_port}"
      echo "AWS_REGION=${var.aws_region}"
      echo "S3_BUCKET=${aws_s3_bucket.upload_bucket.bucket}"
    } > "/opt/csye6225/webapp/.env"

    sudo systemctl daemon-reexec
    sudo systemctl restart amazon-cloudwatch-agent
    sudo systemctl restart webapp
  EOF

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
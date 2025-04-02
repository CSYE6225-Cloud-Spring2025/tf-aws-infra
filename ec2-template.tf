resource "aws_key_pair" "aws_ec2_key" {
  key_name   = var.ec2_key_name
  public_key = file(var.ec2_key_file)
}

resource "aws_launch_template" "webapp_template" {
  name          = "webapp-template"
  image_id      = var.ami_id
  instance_type = var.ec2_instance_type
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.webapp_security_group.id]
  }
  key_name = aws_key_pair.aws_ec2_key.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  user_data = base64encode(<<-EOF
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
  )

  disable_api_termination = false
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 25
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "webapp-server"
    }
  }
}


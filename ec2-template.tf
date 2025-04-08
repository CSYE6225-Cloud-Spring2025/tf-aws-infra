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

    sudo apt-get install -y unzip curl jq
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    DB_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${aws_secretsmanager_secret.db_credentials.id} --region ${var.aws_region} \
      --query SecretString --output text | jq -r .password)
    
    sudo touch /opt/csye6225/webapp/.env
    sudo chmod 666 /opt/csye6225/webapp/.env
    {
      echo "DB_HOST=${aws_db_instance.rds_mysql.address}"
      echo "DB_USER=${var.rds_username}"
      echo "DB_PASSWORD=$DB_PASSWORD"
      echo "DB_NAME=${var.rds_db_name}"
      echo "PORT=${var.webapp_port}"
      echo "AWS_REGION=${var.aws_region}"
      echo "S3_BUCKET=${aws_s3_bucket.upload_bucket.bucket}"
    } > "/opt/csye6225/webapp/.env"
    
    sudo chown ${var.linux_user}:${var.linux_group} /opt/csye6225/webapp/.env
    sudo chmod 640 /opt/csye6225/webapp/.env

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
      encrypted             = true
      kms_key_id            = aws_kms_key.ec2_encryption_key.arn
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "webapp-server"
    }
  }
}


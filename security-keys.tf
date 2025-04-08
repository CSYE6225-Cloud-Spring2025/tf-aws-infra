resource "aws_kms_alias" "ec2_key_alias" {
  name          = "alias/ec2-encryption-key"
  target_key_id = aws_kms_key.ec2_encryption_key.key_id
}

resource "aws_kms_alias" "rds_key_alias" {
  name          = "alias/rds-encryption-key"
  target_key_id = aws_kms_key.rds_encryption_key.key_id
}

resource "aws_kms_alias" "s3_key_alias" {
  name          = "alias/s3-encryption-key"
  target_key_id = aws_kms_key.s3_encryption_key.key_id
}

resource "aws_kms_alias" "secrets_manager_key_alias" {
  name          = "alias/secrets-manager-encryption-key"
  target_key_id = aws_kms_key.secrets_manager_encryption_key.key_id
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "ec2_encryption_key" {
  description             = "EC2 encryption key"
  enable_key_rotation     = true
  rotation_period_in_days = 90
  deletion_window_in_days = 7
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Provide key access to root",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "Provide key access to auto scaling",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ],
        Resource = "*"
      },
      {
        Sid    = "Provide key access to EC2",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.ec2_access.arn
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      }
    ]
  })
  tags = {
    Name = "ec2-encryption-key"
  }
}

resource "aws_kms_key" "rds_encryption_key" {
  description             = "RDS encryption key"
  enable_key_rotation     = true
  rotation_period_in_days = 90
  deletion_window_in_days = 7
  tags = {
    Name = "rds-encryption-key"
  }
}

resource "aws_kms_key" "s3_encryption_key" {
  description             = "S3 encryption key"
  enable_key_rotation     = true
  rotation_period_in_days = 90
  deletion_window_in_days = 7
  tags = {
    Name = "s3-encryption-key"
  }
}

resource "aws_kms_key" "secrets_manager_encryption_key" {
  description             = "Secrets manager encryption key"
  enable_key_rotation     = true
  rotation_period_in_days = 90
  deletion_window_in_days = 7
  tags = {
    Name = "secrets-manager-encryption-key"
  }
}



resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_access.name
}

resource "aws_iam_role" "ec2_access" {
  name = "ec2-access"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# policy to access S3
resource "aws_iam_policy" "upload_bucket_policy" {
  name        = "s3-${random_uuid.bucket_uuid.result}-full-access"
  description = "Allow full access to S3 bucket and its objects"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "s3:*",
        Resource = [
          "${aws_s3_bucket.upload_bucket.arn}",
          "${aws_s3_bucket.upload_bucket.arn}/*"
        ]
      }
    ]
  })
}

# policy to access RDS credentials in Secrets Manager
resource "aws_iam_policy" "rds_secretsmanager_policy" {
  name        = "rds-secretsmanager-policy"
  description = "Allow access to RDS credentials in Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "secretsmanager:GetSecretValue"
        Resource = aws_secretsmanager_secret.db_credentials.arn
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey*",
          "kms:CreateGrant"
        ]
        Resource = aws_kms_key.secrets_manager_encryption_key.arn
      }
    ]
  })
}

# policy to access s3 key in KMS
resource "aws_iam_policy" "s3_kms_policy" {
  name        = "s3-kms-policy"
  description = "Allow access to S3 KMS keys"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ],
        Resource = aws_kms_key.s3_encryption_key.arn
      }
    ]
  })
}

# policy attachment for S3
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ec2_access.name
  policy_arn = aws_iam_policy.upload_bucket_policy.arn
}

# policy attachment for CloudWatch
resource "aws_iam_role_policy_attachment" "cloud_watch_access" {
  role       = aws_iam_role.ec2_access.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# policy attachment for Secrets Manager
resource "aws_iam_role_policy_attachment" "secretsmanager_access" {
  role       = aws_iam_role.ec2_access.name
  policy_arn = aws_iam_policy.rds_secretsmanager_policy.arn
}

# policy attachment for s3 key in KMS
resource "aws_iam_role_policy_attachment" "s3_kms_access" {
  role       = aws_iam_role.ec2_access.name
  policy_arn = aws_iam_policy.s3_kms_policy.arn
}

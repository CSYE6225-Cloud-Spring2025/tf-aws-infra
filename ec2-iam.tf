resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_access_rds_s3.name
}

resource "aws_iam_role" "ec2_access_rds_s3" {
  name = "ec2-access-rds-s3"
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

# policy attachment for RDS
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ec2_access_rds_s3.name
  policy_arn = aws_iam_policy.upload_bucket_policy.arn
}

# policy attachment for CloudWatch
resource "aws_iam_role_policy_attachment" "cloud_watch_access" {
  role       = aws_iam_role.ec2_access_rds_s3.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
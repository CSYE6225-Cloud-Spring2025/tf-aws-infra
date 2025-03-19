resource "aws_iam_role" "ec2_access_rds" {
  name = "ec2-access-rds"
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

resource "aws_iam_role_policy_attachment" "rds_access" {
  role       = aws_iam_role.ec2_access_rds.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_instance_profile" "ec2_rds_profile" {
  name = "ec2-rds-profile"
  role = aws_iam_role.ec2_access_rds.name
}
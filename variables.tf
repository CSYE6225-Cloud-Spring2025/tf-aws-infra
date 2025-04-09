variable "profile" {
  type        = string
  description = "AWS profile name"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr_range" {
  description = "VPC CIDR range"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "public_cidr_range" {
  description = "Public cidr range"
  type        = list(string)
}

variable "private_cidr_range" {
  description = "Private cidr range"
  type        = list(string)
}

variable "webapp_port" {
  description = "Webapp application port"
  type        = string
}

variable "ami_id" {
  description = "ID of the created AMI"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "rds_db_name" {
  description = "RDS name"
  type        = string
}

variable "rds_username" {
  description = "Username to access RDS"
  type        = string
}

variable "linux_group" {
  description = "Linux group name to run app"
  type        = string
}

variable "linux_user" {
  description = "Linux user name to run app"
  type        = string
}

variable "route53_zone_id" {
  description = "The hosted zone ID in Route53"
  type        = string
}

variable "domain_name" {
  description = "Domain name configured in hosted zone"
  type        = string
}

variable "ec2_template_name" {
  description = "EC2 template name"
  type        = string
}

variable "autoscaling_group_name" {
  description = "Auto-scaling group name"
  type        = string
}
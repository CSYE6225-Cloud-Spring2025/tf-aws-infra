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
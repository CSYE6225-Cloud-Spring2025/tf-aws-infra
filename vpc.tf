resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr_range
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "${var.vpc_name}-internet-gateway"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.0, <6.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.profile
}
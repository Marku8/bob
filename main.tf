provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# Subnets
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_eip" "nat" {
  vpc = true
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# # EC2 Instance
# resource "aws_instance" "example" {
#   ami           = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI ID for your region
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.private.id

#   tags = {
#     Name = "ExampleInstance"
#   }
# }

# S3 Bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-cloudtrail-logs1"

}

resource "aws_s3_bucket_public_access_block" "log_bucket_access_block" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "log_bucket_logging" {
  bucket = aws_s3_bucket.log_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# CloudTrail
resource "aws_cloudtrail" "example" {
  name                          = "example"
  s3_bucket_name                = aws_s3_bucket.log_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
}


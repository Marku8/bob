# Outputs
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

# output "ec2_instance_id" {
#   value = aws_instance.example.id
# }

output "s3_bucket_id" {
  value = aws_s3_bucket.log_bucket.id
}

output "cloudtrail_id" {
  value = aws_cloudtrail.example.id
}

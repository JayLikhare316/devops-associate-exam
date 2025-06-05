provider "aws" {
  region = "us-east-1"  # You can change this to your preferred region
}

resource "aws_s3_bucket" "devops_bucket" {
  bucket = "devops-assoc-bucket"
  
  tags = {
    Name        = "DevOps Associate Bucket"
    Environment = "DevOpsTest"
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.devops_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

provider "aws" {
  region = "us-east-1"  # You can change this to your preferred region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "devops_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  
  tags = {
    Name        = "DevOps-EC2-Instance"
    Environment = "DevOpsTest"
  }
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.devops_instance.public_ip
}

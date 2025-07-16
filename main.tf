Generated terraform

      
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # You can change this to your desired AWS region
}

# Create a new EC2 instance
resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0" # This is a common Amazon Linux 2 AMI for us-east-1. Verify a current one for your region if needed.
  instance_type = "t2.micro"             # This is eligible for the AWS Free Tier.

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

    

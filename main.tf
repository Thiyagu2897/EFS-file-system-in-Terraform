provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Create an Elastic File System
resource "aws_efs_file_system" "example" {
  creation_token = "my-efs-token"  # A unique identifier for your EFS

  # Optional settings
  performance_mode    = "generalPurpose" # Can be "maxIO" or "generalPurpose"
  throughput_mode     = "bursting"       # Can be "provisioned" or "bursting"
  encrypted           = true             # Set to true to enable encryption
  availability_zone_name="us-east-1f"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"   # Transition to Infrequent Access after 30 days

   
  }

  tags = {
    Name = "example-efs"
  }
}

# Security Group for EFS
resource "aws_security_group" "efs_sg" {
  name_prefix = "efs_sg"
  vpc_id      = "vpc-00ba1e60b231d33eb"  # Replace with your VPC ID

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"] # Replace with your VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Mount Targets for each availability zone
resource "aws_efs_mount_target" "example_mount_target_a" {
  file_system_id  = aws_efs_file_system.example.id
  subnet_id       = "subnet-06a742beab6bbf815" # Replace with your subnet in AZ A
  security_groups = [aws_security_group.efs_sg.id]
}

# resource "aws_efs_mount_target" "example_mount_target_b" {
#   file_system_id  = aws_efs_file_system.example.id
#   subnet_id       = "subnet-0cbf9338934241500" # Replace with your subnet in AZ B
#   security_groups = [aws_security_group.efs_sg.id]
# }

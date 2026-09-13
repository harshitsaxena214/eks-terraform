terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region where the state bucket will be created"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used to name the state bucket"
  type        = string
  default     = "eks-three-stage"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project_name}-terraform-state-${data.aws_caller_identity.current.account_id}"

  # Prevent accidental deletion of this bucket (it holds all your state!)
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "${var.project_name}-terraform-state"
    Project     = var.project_name
    ManagedBy   = "terraform"
    Description = "Stores Terraform remote state for all environments"
  }
}

# Enable versioning so you can recover from accidental state corruption
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt state at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access â€” state files must NEVER be public
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_caller_identity" "current" {}

output "state_bucket_name" {
  description = "Name of the S3 bucket. Copy this into each environment's backend.tf"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket_region" {
  description = "Region of the S3 bucket"
  value       = var.aws_region
}


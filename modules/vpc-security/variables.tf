# ==============================================================================
# modules/vpc-security/variables.tf
# Input variables for the vpc-security module
# ==============================================================================

# --- General ---

variable "project_name" {
  description = "Project name used for tagging and naming all resources"
  type        = string
}

variable "environment" {
  description = "Environment label (e.g. dev, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

# --- Network ---

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for app layer subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "data_subnet_cidrs" {
  description = "CIDR blocks for data layer subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

# --- Access Control ---

variable "allowed_ssh_cidr" {
  description = "Public IP in CIDR notation allowed to SSH into the bastion host"
  type        = string

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "allowed_ssh_cidr must be a valid CIDR block (e.g. 203.0.113.5/32)."
  }
}

# --- EC2 ---

variable "key_pair_name" {
  description = "Name of the EC2 key pair for SSH access"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for bastion, app, and data instances"
  type        = string
  default     = "t2.micro"
}

# --- Flow Logs ---

variable "flow_logs_retention_days" {
  description = "Number of days to retain VPC Flow Logs in CloudWatch"
  type        = number
  default     = 7
}

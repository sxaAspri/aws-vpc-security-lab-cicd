# ==============================================================================
# environments/dev/variables.tf
# ==============================================================================

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "vpc-security-lab"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "data_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

# No default — must be provided via TF_VAR or terraform.tfvars (never hardcoded)
variable "allowed_ssh_cidr" {
  type        = string
  description = "Your public IP in CIDR notation (e.g. 203.0.113.5/32)"
}

variable "key_pair_name" {
  type        = string
  description = "Name of the EC2 key pair"
  default     = "vpc-security-lab-key"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "flow_logs_retention_days" {
  type    = number
  default = 7
}

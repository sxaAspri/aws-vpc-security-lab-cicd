# ==============================================================================
# environments/dev/main.tf
# Instantiates the vpc-security module for the dev environment
# ==============================================================================

module "vpc_security" {
  source = "../../modules/vpc-security"

  # General
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  # Network — dev uses default CIDRs, override here if needed
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  app_subnet_cidrs    = var.app_subnet_cidrs
  data_subnet_cidrs   = var.data_subnet_cidrs

  # Access control — never hardcoded, always passed as variable
  allowed_ssh_cidr = var.allowed_ssh_cidr

  # EC2
  key_pair_name = var.key_pair_name
  instance_type = var.instance_type

  # Flow logs
  flow_logs_retention_days = var.flow_logs_retention_days
}

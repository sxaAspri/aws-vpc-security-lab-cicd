# ==============================================================================
# environments/dev/backend.tf
# Remote state in S3 with DynamoDB locking — dev prefix
# Fill in your bucket name before running terraform init
# ==============================================================================

terraform {
  backend "s3" {
    bucket         = "tf-state-vpc-security-474945406391"
    key            = "vpc-security-lab/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

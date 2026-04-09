# ==============================================================================
# modules/vpc-security/subnets.tf
# Three-tier subnet layout across two AZs
# ==============================================================================

# --- Public subnets ---

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-a"
    Tier = "public"
  })
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-b"
    Tier = "public"
  })
}

# --- App subnets ---

resource "aws_subnet" "app_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_cidrs[0]
  availability_zone = "${var.aws_region}a"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-app-a"
    Tier = "app"
  })
}

resource "aws_subnet" "app_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_cidrs[1]
  availability_zone = "${var.aws_region}b"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-app-b"
    Tier = "app"
  })
}

# --- Data subnets ---

resource "aws_subnet" "data_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.data_subnet_cidrs[0]
  availability_zone = "${var.aws_region}a"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-data-a"
    Tier = "data"
  })
}

resource "aws_subnet" "data_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.data_subnet_cidrs[1]
  availability_zone = "${var.aws_region}b"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-data-b"
    Tier = "data"
  })
}

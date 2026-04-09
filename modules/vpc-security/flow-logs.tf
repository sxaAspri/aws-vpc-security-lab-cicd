# ==============================================================================
# modules/vpc-security/flow-logs.tf
# VPC Flow Logs, CloudWatch log group, IAM role, metric filter, and alarm
# ==============================================================================

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "/aws/vpc/${var.project_name}-flow-logs"
  retention_in_days = var.flow_logs_retention_days

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-flow-logs"
  })
}

resource "aws_iam_role" "flow_logs" {
  name = "${var.project_name}-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-flow-logs-role"
  })
}

resource "aws_iam_role_policy" "flow_logs" {
  name = "${var.project_name}-flow-logs-policy"
  role = aws_iam_role.flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_flow_log" "main" {
  vpc_id          = aws_vpc.main.id
  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.flow_logs.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-flow-log"
  })
}

resource "aws_cloudwatch_log_metric_filter" "rejected_data" {
  name           = "${var.project_name}-rejected-to-data"
  log_group_name = aws_cloudwatch_log_group.flow_logs.name
  pattern        = "[version, account, eni, source, destination, srcport, destport=\"5432\", protocol, packets, bytes, windowstart, windowend, action=\"REJECT\", flowlogstatus]"

  metric_transformation {
    name      = "RejectedToData"
    namespace = "${var.project_name}/NetworkSecurity"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "rejected_data" {
  alarm_name          = "${var.project_name}-rejected-to-data-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "RejectedToData"
  namespace           = "${var.project_name}/NetworkSecurity"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Rejected traffic to data layer detected"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-rejected-data-alarm"
  })
}

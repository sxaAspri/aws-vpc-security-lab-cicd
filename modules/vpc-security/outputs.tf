# ==============================================================================
# modules/vpc-security/outputs.tf
# Values exposed to the environment caller
# ==============================================================================

output "vpc_id" {
  description = "ID of the main VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "app_subnet_ids" {
  description = "IDs of the app layer subnets"
  value       = [aws_subnet.app_a.id, aws_subnet.app_b.id]
}

output "data_subnet_ids" {
  description = "IDs of the data layer subnets"
  value       = [aws_subnet.data_a.id, aws_subnet.data_b.id]
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "app_private_ip" {
  description = "Private IP of the app EC2 instance"
  value       = aws_instance.app.private_ip
}

output "data_private_ip" {
  description = "Private IP of the data EC2 instance"
  value       = aws_instance.data.private_ip
}

output "flow_log_group" {
  description = "Name of the VPC Flow Logs CloudWatch log group"
  value       = aws_cloudwatch_log_group.flow_logs.name
}

output "alarm_name" {
  description = "Name of the rejected traffic CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.rejected_data.alarm_name
}

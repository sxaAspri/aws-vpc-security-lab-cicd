# ==============================================================================
# environments/dev/outputs.tf
# Passes module outputs up to the environment level
# ==============================================================================

output "vpc_id" {
  value = module.vpc_security.vpc_id
}

output "bastion_public_ip" {
  value = module.vpc_security.bastion_public_ip
}

output "app_private_ip" {
  value = module.vpc_security.app_private_ip
}

output "data_private_ip" {
  value = module.vpc_security.data_private_ip
}

output "flow_log_group" {
  value = module.vpc_security.flow_log_group
}

output "alarm_name" {
  value = module.vpc_security.alarm_name
}

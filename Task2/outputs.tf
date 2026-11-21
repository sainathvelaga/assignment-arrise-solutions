output "instance_ids" {
  description = "Map of instance names to their IDs"
  value       = module.ec2_instances.instance_ids
}

output "instance_private_ips" {
  description = "Map of instance names to their private IPs"
  value       = module.ec2_instances.instance_private_ips
}

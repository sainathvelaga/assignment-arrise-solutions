output "instance_ids" {
  description = "Map of instance names to their IDs"
  value = merge(
    { for name, instance in aws_instance.protected : name => instance.id },
    { for name, instance in aws_instance.standard : name => instance.id }
  )
}

output "instance_private_ips" {
  description = "Map of instance names to their private IPs"
  value = merge(
    { for name, instance in aws_instance.protected : name => instance.private_ip },
    { for name, instance in aws_instance.standard : name => instance.private_ip }
  )
}

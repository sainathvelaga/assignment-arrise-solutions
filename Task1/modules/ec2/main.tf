resource "aws_instance" "protected" {
  for_each = local.protected_instances

  ami           = var.ami_id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  subnet_id     = var.subnet_id

  root_block_device {
    volume_type           = each.value.root_volume_type
    volume_size           = each.value.root_volume_size
    iops                  = contains(["io1", "io2"], each.value.root_volume_type) ? each.value.root_volume_iops : null
    delete_on_termination = false
  }

  tags = {
    Name        = each.key
    Environment = each.value.environment
    Owner       = each.value.owner
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_instance" "standard" {
  for_each = local.standard_instances

  ami           = var.ami_id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  subnet_id     = var.subnet_id

  root_block_device {
    volume_type           = each.value.root_volume_type
    volume_size           = each.value.root_volume_size
    iops                  = contains(["io1", "io2"], each.value.root_volume_type) ? each.value.root_volume_iops : null
    delete_on_termination = true
  }

  tags = {
    Name        = each.key
    Environment = each.value.environment
    Owner       = each.value.owner
  }
}
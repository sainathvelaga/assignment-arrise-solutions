resource "aws_key_pair" "this" {
  for_each = var.key_pairs

  key_name   = each.key
  public_key = file(each.value)
}



module "ec2_instances" {
  source = "../Task1/modules/ec2"

  ami_id    = var.ami_id
  subnet_id = var.subnet_id
  instances = var.instances

  depends_on = [aws_key_pair.this]
}

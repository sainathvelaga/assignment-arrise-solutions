variable "ami_id" {
  description = "AMI ID to use for the EC2 instances"
  type        = string
}

variable "subnet_id" {
  description = "VPC Subnet ID where instances will be deployed"
  type        = string
}

variable "instances" {
  description = "Map of EC2 instances to provision, keyed by instance Name"
  type = map(object({
    instance_type    = string
    root_volume_type = string
    root_volume_size = number
    root_volume_iops = optional(number)
    key_name         = string
    environment      = string
    owner            = string
    prevent_destroy  = optional(bool, false)
  }))

  validation {
    condition = alltrue([
      for k, v in var.instances :
      !contains(["io1", "io2"], v.root_volume_type) || (v.root_volume_iops != null && v.root_volume_iops >= 100)
    ])
    error_message = "Instances using 'io1' or 'io2' root_volume_type must specify 'root_volume_iops' >= 100."
  }
}

variable "key_pairs" {
  description = "Map of AWS key pair names to public key file paths"
  type        = map(string)
}

# Task 1: Multi-Instance EC2 Module

## Prerequisites: EC2 Key Pairs

The module expects the EC2 key pairs to already exist in the target AWS Region.
The key pair names are supplied through the `instances` variable:

- `web-key`
- `app-key`
- `db-key`
- `admin-key`
- `worker-key`

Before running `terraform apply`, create these five key pairs in:

AWS Console → EC2 → Key Pairs → Create key pair

Alternatively, create them using the AWS CLI:

```bash
aws ec2 create-key-pair \
  --key-name web-key \
  --query KeyMaterial \
  --output text > web-key.pem

aws ec2 create-key-pair \
  --key-name app-key \
  --query KeyMaterial \
  --output text > app-key.pem

aws ec2 create-key-pair \
  --key-name db-key \
  --query KeyMaterial \
  --output text > db-key.pem

aws ec2 create-key-pair \
  --key-name admin-key \
  --query KeyMaterial \
  --output text > admin-key.pem

aws ec2 create-key-pair \
  --key-name worker-key \
  --query KeyMaterial \
  --output text > worker-key.pem
```

The key pair names must match the `key_name` values in `terraform.tfvars`.
The downloaded private key files should be stored securely and must not be committed
to version control.

The key pairs must be created in the same AWS Region configured for this Terraform
deployment.
```

I've set this up as a reusable Terraform module in the `modules/ec2` directory. It's designed to be flexible, so you can spin up multiple instances with different specs just by updating a single map variable.

### About the "Protected" Instance
I chose to protect the **`web-server`** instance. 

Since it's a production web server using `io1` (Provisioned IOPS), it's obviously a critical part of the infrastructure. I added a `lifecycle` block with `prevent_destroy = true` to make sure it doesn't get nuked by a stray `terraform destroy` or an accidental configuration change. It’s better to have that extra layer of safety for anything sitting in a Prod environment.

### How it works
*   **Single Input for Everything:** Instead of writing five different resource blocks, I used a `for_each` loop. You just define your instances in `terraform.tfvars` (or any map variable), and the module handles the rest.
*   **The Lifecycle Workaround:** Terraform doesn't let us use variables inside a `lifecycle` block, which is a bit of a pain. To get around this while keeping a single input variable, I used a local filter to split the instances into two groups: one for the protected instance and one for the standard ones.
*   **Storage & Specs:** All instances have different types and storage. I made sure to include both `io1` and `io2` storage types to meet the high-performance requirement.
*   **Tagging:** Every instance automatically gets the `Name`, `Environment`, and `Owner` tags based on what you provide in the map.
*   **Outputs:** Once it's deployed, you'll get a clean map showing each instance's Name linked to its ID and Private IP.

You can find the core logic in `modules/ec2/main.tf` and the variables setup in `variables.tf`.



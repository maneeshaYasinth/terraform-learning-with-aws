# Day 1 - EC2 Setup (Terraform Study Notes)

## Goal
Set up a basic Ubuntu EC2 instance on AWS using Terraform and connect with SSH.

## What I configured
- AWS provider with region: `eu-north-1`
- EC2 key pair from my local SSH public key:
  - `linux_deployer_key`
  - source key file: `C:/Users/maneesha yasinth/.ssh/id_ed25519.pub`
- Security group `day1_security_group` with:
  - inbound SSH (`22`) from `0.0.0.0/0`
  - inbound HTTP (`80`) from `0.0.0.0/0`
  - all outbound traffic allowed
- Latest Ubuntu 22.04 LTS AMI (Canonical) using `data "aws_ami"`
- EC2 instance:
  - type: `t3.micro`
  - tag: `linux-learner-EC2-Instance`
  - key pair + security group attached
- Output:
  - `public_ip` to quickly get instance public IP after apply

## Terraform files in this folder
- `main.tf` -> provider, key pair, security group, AMI lookup, EC2 resource
- `outputs.tf` -> instance public IP output

## Commands I used
```bash
terraform init
terraform plan
terraform apply
```

## What I learned
- Terraform can create AWS networking/security + compute resources in one flow.
- Using `data` sources is useful to fetch latest AMI dynamically instead of hardcoding AMI IDs.
- Outputs help quickly use important values (like public IP) after provisioning.
- Key pair management is important for SSH access to Linux instances.

## Notes for improvement (next step)
- Restrict SSH ingress to my own IP instead of `0.0.0.0/0` for better security.
- Add `user_data` to auto-install packages (like Nginx).
- Move reusable values (region, instance type, ports) into variables.
- Add remote backend (S3 + DynamoDB lock) for safer state management.

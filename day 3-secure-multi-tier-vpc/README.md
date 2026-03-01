# day3-secure-multi-tier-vpc

A production-style Terraform project that builds a secure **multi-tier AWS VPC** with controlled access:
- A **public subnet** for a bastion host (administrative entry point)
- A **private subnet** for an internal web server
- Controlled outbound internet access from private resources via **NAT Gateway**

---

## Project Overview

The goal of this project is to create a secure and practical network foundation on AWS using Terraform. It demonstrates a common real-world design pattern where:

- Public access is limited to a bastion host in a public subnet
- Application servers remain in a private subnet without public IPs
- Internet egress from private instances is routed through a NAT Gateway
- Security groups enforce least-privilege traffic rules

This architecture is ideal for learning AWS networking, security boundaries, and Infrastructure as Code best practices.

---

## Architecture Diagram

### Visual

![Secure multi-tier VPC architecture](images/3%20tire%20with%20bastion%20host.png)

### Network Layout (How It Works)

1. **VPC**
   - A dedicated VPC is created with CIDR block `10.0.0.0/16` (default).

2. **Public Subnet (`10.0.1.0/24`)**
   - Hosts the **Bastion EC2 instance**.
   - Associated with a public route table that sends `0.0.0.0/0` traffic to the **Internet Gateway**.
   - Bastion receives a public IP for SSH administration.

3. **Private Subnet (`10.0.2.0/24`)**
   - Hosts the **Private Web EC2 instance**.
   - No public IP assignment.
   - Uses a private route table that sends `0.0.0.0/0` traffic to the **NAT Gateway**.

4. **Internet Gateway (IGW)**
   - Attached to the VPC to allow internet access for public resources.

5. **NAT Gateway + Elastic IP**
   - NAT Gateway is deployed in the public subnet with an Elastic IP.
   - Enables outbound internet connectivity for private instances (for updates/packages) without exposing them publicly.

6. **Security Groups**
   - **Bastion SG**: Allows inbound SSH (`22`) from a configurable CIDR (currently open by default).
   - **Private Web SG**:
     - Allows SSH (`22`) from bastion security group
     - Allows HTTP (`80`) from inside VPC CIDR (`10.0.0.0/16` default)
     - Allows outbound traffic

---

## Resources Created

This Terraform code provisions the following AWS resources:

- `aws_vpc.main`
- `aws_subnet.public_subnet`
- `aws_subnet.private_subnet`
- `aws_internet_gateway.igw`
- `aws_eip.nat_eip`
- `aws_nat_gateway.nat`
- `aws_route_table.public_rt`
- `aws_route_table.private_rt`
- `aws_route_table_association.public_assoc`
- `aws_route_table_association.private_assoc`
- `aws_key_pair.multi-tier-deployer`
- `aws_security_group.bastion_sg`
- `aws_security_group.private_sg`
- `aws_instance.bastion`
- `aws_instance.private_web`
- `data.aws_ami.ubuntu` (Ubuntu 22.04 AMI lookup)

---

## Setup Instructions

### 1) Prerequisites

- AWS account and IAM credentials configured locally
- Terraform installed (v1.x)
- An existing SSH key pair on your local machine (public key file path needed)

### 2) Configure Variables

Defaults are defined in `variable.tf`, but you should set environment-specific values using a `terraform.tfvars` file.

Create `terraform.tfvars` in this folder:

```hcl
aws_region                          = "eu-north-1"
public_key_path                     = "C:/Users/<your-user>/.ssh/id_ed25519.pub"

# Optional customizations
vpc_name                            = "day3-multi-tier-vpc"
vpc_cidr_block_range                = "10.0.0.0/16"
public_subnet_cidr_range            = "10.0.1.0/24"
private_subnet_cidr_range           = "10.0.2.0/24"
public_subnet_availability_zone     = "eu-north-1a"
private_subnet_availability_zone    = "eu-north-1a"

# Strongly recommended for security in real environments
bastion_sg_indress1_cidr_blocks     = ["<your-public-ip>/32"]
```

> Tip: To find your public IP quickly, search “what is my IP”, then use `/32` CIDR.

### 3) Initialize Terraform

```bash
terraform init
```

### 4) Review Execution Plan

```bash
terraform plan
```

Optionally pass a specific variables file:

```bash
terraform plan -var-file="terraform.tfvars"
```

### 5) Apply Infrastructure

```bash
terraform apply
```

Or with explicit var file:

```bash
terraform apply -var-file="terraform.tfvars"
```

Type `yes` when prompted.

---

## SSH Access Instructions

After apply completes, get output values:

```bash
terraform output
```

### Step 1: Connect to Bastion Host

```bash
ssh -i ~/.ssh/id_ed25519 ubuntu@<bastion_public_ip>
```

On Windows PowerShell (if needed):

```powershell
ssh -i C:/Users/<your-user>/.ssh/id_ed25519 ubuntu@<bastion_public_ip>
```

### Step 2: Connect to Private Instance Through Bastion

Use the private IP from Terraform output `private_instance_private_ip`.

#### Option A: Two-step SSH

1. SSH to bastion
2. From bastion:

```bash
ssh -i ~/.ssh/id_ed25519 ubuntu@<private_instance_private_ip>
```

#### Option B: Single command with ProxyJump (from local machine)

```bash
ssh -i ~/.ssh/id_ed25519 -J ubuntu@<bastion_public_ip> ubuntu@<private_instance_private_ip>
```

---

## Testing

### Verify Internal Connectivity

From the bastion host:

```bash
ping -c 3 <private_instance_private_ip>
```

### Verify Web Server on Private Instance

From bastion host:

```bash
curl http://<private_instance_private_ip>
```

If the private instance does not yet have a web server running, install one after SSHing into the private instance:

```bash
sudo apt update
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```

Then run `curl` again from bastion.

---

## Notes (Security & Best Practices)

- Restrict bastion SSH ingress (`bastion_sg_indress1_cidr_blocks`) to your IP instead of `0.0.0.0/0`.
- Keep the private instance in a private subnet with no public IP.
- Use key-based SSH access; never store private keys in this repository.
- Rotate keys and enforce least-privilege IAM policies for Terraform execution.
- Consider replacing bastion SSH with AWS Systems Manager Session Manager for stronger security.

---

## Outputs

This project currently exports:

- `bastion_public_ip` – Public IP of bastion host
- `bastion_public_dns` – Public DNS name of bastion host
- `private_instance_private_ip` – Private IP of web server instance
- `vpc_id` – Created VPC ID
- `private_subnet_id` – Private subnet ID

Useful commands:

```bash
terraform output
terraform output bastion_public_ip
terraform output private_instance_private_ip
```

> Note: If you also want `public_subnet_id` as an output, add it in `outputs.tf` similarly to `private_subnet_id`.

---

## Cleanup

To avoid ongoing AWS charges:

```bash
terraform destroy
```

Review the destroy plan and type `yes` to confirm.

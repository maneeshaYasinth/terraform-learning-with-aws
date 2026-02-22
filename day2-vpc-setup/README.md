# 🚀 Terraform AWS VPC Setup with EC2

A comprehensive Terraform project demonstrating infrastructure as code (IaC) best practices by deploying a fully functional AWS VPC with public subnet, Internet Gateway, security groups, and EC2 instances.

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Architecture Diagram](#-architecture-diagram)
- [Terraform Resources](#-terraform-resources-used)
- [Variables](#-variables)
- [Prerequisites](#-prerequisites)
- [How to Run](#-how-to-run)
- [Accessing Your EC2 Instance](#-accessing-your-ec2-instance)
- [Results & Outputs](#-results--outputs)
- [Next Steps & Improvements](#-next-steps--improvements)
- [Troubleshooting](#-troubleshooting)
- [Additional Resources](#-additional-resources)

---

## 📅 Today's Work (February 23, 2026)

### ✅ Completed Tasks

- ✅ Created custom VPC with CIDR block `10.0.0.0/16`
- ✅ Set up public subnet with CIDR `10.0.1.0/24`
- ✅ Configured Internet Gateway for internet connectivity
- ✅ Created route table and associated with public subnet
- ✅ Deployed security group allowing SSH (port 22) and HTTP (port 80)
- ✅ Generated and registered SSH key pair (`vpc_deployer_key`)
- ✅ Launched EC2 instance (t3.micro) with Ubuntu 22.04 LTS
- ✅ Assigned public IP to EC2 instance: **13.51.174.30**
- ✅ Created comprehensive README documentation

### 📊 Deployment Summary

| Resource | Status | Details |
|----------|--------|---------|
| VPC | ✅ Created | 10.0.0.0/16 |
| Public Subnet | ✅ Created | 10.0.1.0/24 |
| Internet Gateway | ✅ Created | Attached to VPC |
| Route Table | ✅ Created | Routes to IGW |
| Security Group | ✅ Created | SSH + HTTP rules |
| EC2 Instance | ✅ Running | t3.micro, Ubuntu 22.04 LTS |
| SSH Key Pair | ✅ Registered | vpc_deployer_key |
| **Public IP** | ✅ **Assigned** | **<EC2_PUBLIC_IP>** |

### 🔐 SSH Access Command

```bash
ssh -i $HOME\.ssh\id_ed25519 ubuntu@<EC2_PUBLIC_IP>
```

---

## 🎯 Project Overview

This Terraform project demonstrates **Enterprise-grade infrastructure deployment** on AWS. It creates a complete, production-ready VPC environment with proper network segmentation, internet connectivity, and secure access to compute resources.

### What This Project Creates:

✅ **Custom VPC** with private IP space (10.0.0.0/16)  
✅ **Public Subnet** for internet-facing resources  
✅ **Internet Gateway** for internet connectivity  
✅ **Route Table** for traffic routing  
✅ **Security Group** with SSH and HTTP access controls  
✅ **EC2 Instance** running latest Ubuntu LTS  
✅ **SSH Key Pair** for secure access  

### Key Learning Outcomes:

- Understanding AWS VPC architecture and networking
- Managing cloud resources with Terraform
- Implementing infrastructure security best practices
- Using data sources to fetch latest AMI images
- Managing SSH keys and secure access

---

## 🏗️ Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        AWS Account (eu-north-1)                 │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              VPC: 10.0.0.0/16                             │  │
│  │                                                            │  │
│  │  ┌────────────────────────────────────────────────────┐   │  │
│  │  │  Public Subnet: 10.0.1.0/24                        │   │  │
│  │  │  (map_public_ip_on_launch = true)                  │   │  │
│  │  │                                                    │   │  │
│  │  │  ┌──────────────────────────────────────────────┐  │   │  │
│  │  │  │  EC2 Instance (t3.micro)                    │  │   │  │
│  │  │  │  - Ubuntu 22.04 LTS                         │  │   │  │
│  │  │  │  - Public IP (Auto-assigned)                │  │   │  │
│  │  │  │  - SSH Access via Key Pair                  │  │   │  │
│  │  │  └──────────────────────────────────────────────┘  │   │  │
│  │  │                                                    │   │  │
│  │  │  ┌──────────────────────────────────────────────┐  │   │  │
│  │  │  │  Security Group: web-sg                     │  │   │  │
│  │  │  │  - SSH (Port 22): 0.0.0.0/0                 │  │   │  │
│  │  │  │  - HTTP (Port 80): 0.0.0.0/0                │  │   │  │
│  │  │  │  - Egress: All traffic allowed              │  │   │  │
│  │  │  └──────────────────────────────────────────────┘  │   │  │
│  │  └────────────────────────────────────────────────────┘   │  │
│  │                          ▲                                 │  │
│  │                          │                                 │  │
│  │  ┌──────────────────────┘──────────────────────────────┐  │  │
│  │  │  Route Table: 0.0.0.0/0 → Internet Gateway         │  │  │
│  │  └──────────────────────────────────────────────────────┘  │  │
│  │                          ▲                                 │  │
│  │                          │                                 │  │
│  │  ┌──────────────────────┴──────────────────────────────┐  │  │
│  │  │  Internet Gateway (IGW)                            │  │  │
│  │  └──────────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────┘  │
│                          ▲                                       │
│                          │                                       │
└──────────────────────────┼───────────────────────────────────────┘
                           │
                    ┌──────┴──────┐
                    │             │
                  🌐 Internet 🌐
```

### Architecture Components:

| Component | Details |
|-----------|---------|
| **VPC** | 10.0.0.0/16 - Custom IP range for your AWS resources |
| **Public Subnet** | 10.0.1.0/24 - Subnet for internet-facing resources |
| **Internet Gateway** | Enables VPC to communicate with the internet |
| **Route Table** | Routes traffic destined for 0.0.0.0/0 to IGW |
| **Security Group** | Firewall rules allowing SSH and HTTP inbound traffic |
| **EC2 Instance** | Ubuntu 22.04 LTS server with public IP assignment |
| **Key Pair** | SSH key for secure access to the instance |

---

## 🏛️ Terraform Resources Used

This project implements the following AWS resources:

### Core Networking

| Resource | Purpose | Terraform Reference |
|----------|---------|-------------------|
| `aws_vpc` | Create custom Virtual Private Cloud | `aws_vpc.main` |
| `aws_subnet` | Create public subnet within VPC | `aws_subnet.public_subnet` |
| `aws_internet_gateway` | Enable internet connectivity | `aws_internet_gateway.igw` |
| `aws_route_table` | Define traffic routing rules | `aws_route_table.public_rt` |
| `aws_route_table_association` | Associate subnet with route table | `aws_route_table_association.public_assoc` |

### Security & Access

| Resource | Purpose | Terraform Reference |
|----------|---------|-------------------|
| `aws_security_group` | Firewall rules for traffic | `aws_security_group.web_sg` |
| `aws_key_pair` | SSH key pair for EC2 access | `aws_key_pair.vpc_deployer` |

### Compute

| Resource | Purpose | Terraform Reference |
|----------|---------|-------------------|
| `aws_instance` | EC2 instance with Ubuntu | `aws_instance.day2_ec2` |
| `data "aws_ami"` | Fetch latest Ubuntu 22.04 LTS | `data.aws_ami.ubuntu` |

---

## 📝 Variables

The project uses customizable variables for flexibility. Below is the complete variable configuration:

### Network Variables

```hcl
variable "region_name"
  • Type: string
  • Default: "eu-north-1"
  • Purpose: AWS region where resources will be created
  
variable "vpc_name"
  • Type: string
  • Default: "custom-vpc"
  • Purpose: Name tag for the VPC
  
variable "vpc_cidr_block_range"
  • Type: string
  • Default: "10.0.0.0/16"
  • Purpose: CIDR block for the entire VPC
  
variable "public_subnet_cidr"
  • Type: string
  • Default: "10.0.1.0/24"
  • Purpose: CIDR block for public subnet
  
variable "public_subnet_AZ"
  • Type: string
  • Default: "eu-north-1a"
  • Purpose: Availability Zone for subnet
  
variable "public_subnet_name"
  • Type: string
  • Default: "public-subnet"
  • Purpose: Name tag for subnet
  
variable "igw_name"
  • Type: string
  • Default: "main-igw"
  • Purpose: Name tag for Internet Gateway
  
variable "public_route_table_name"
  • Type: string
  • Default: "public-route-table"
  • Purpose: Name tag for route table
```

### Security Variables

```hcl
variable "key_pair_name"
  • Type: string
  • Default: "vpc_deployer_key"
  • Purpose: Name of the SSH key pair
  
variable "public_key_path"
  • Type: string
  • Default: "~/.ssh/id_ed25519.pub"
  • Purpose: Path to public key file
  
variable "sg_name"
  • Type: string
  • Default: "web-security-group"
  • Purpose: Name of security group
  
variable "sg_description"
  • Type: string
  • Default: "Security group for web servers"
  • Purpose: Description of security group
```

### Security Group Rules

```hcl
# INGRESS Rules (Inbound Traffic)

web_sg_ingress1 - HTTP
  • Description: "Allow HTTP"
  • Port: 80
  • Protocol: tcp
  • CIDR: 0.0.0.0/0 (Open to internet)
  
web_sg_ingress2 - SSH
  • Description: "Allow SSH"
  • Port: 22
  • Protocol: tcp
  • CIDR: 0.0.0.0/0 (Open to internet)

# EGRESS Rules (Outbound Traffic)

web_sg_egress - All Traffic
  • Description: "Allow all outbound traffic"
  • Protocol: -1 (All protocols)
  • CIDR: 0.0.0.0/0 (Unrestricted)
```

### EC2 Instance Variables

```hcl
variable "ec2_type"
  • Type: string
  • Default: "t3.micro"
  • Purpose: EC2 instance type (eligible for free tier)
  
variable "ec2_name"
  • Type: string
  • Default: "web-server"
  • Purpose: Name tag for EC2 instance
```

### Custom Variables

To override default values, create a `terraform.tfvars` file:

```hcl
region_name = "us-east-1"
vpc_cidr_block_range = "10.1.0.0/16"
ec2_type = "t3.small"
```

---

## ✅ Prerequisites

Before running this Terraform project, ensure you have:

### Required Software

- ✅ **Terraform** (v1.0 or higher)
  ```bash
  # Verify installation
  terraform --version
  ```

- ✅ **AWS CLI** (v2 recommended)
  ```bash
  # Verify installation
  aws --version
  ```

- ✅ **SSH Key Pair**
  ```bash
  # Generate SSH key pair if you don't have one
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
  
  # On Windows PowerShell
  ssh-keygen -t ed25519 -f $HOME\.ssh\id_ed25519
  ```

### AWS Account Setup

- ✅ **AWS Account** with appropriate permissions
- ✅ **AWS Credentials** configured
  ```bash
  aws configure
  # Enter: Access Key ID, Secret Access Key, Region, Output Format
  ```

- ✅ **IAM Permissions** required:
  - `ec2:*` (EC2 full access)
  - `vpc:*` (VPC full access)

### Verify Prerequisites

```bash
# Check Terraform
terraform -version

# Check AWS CLI
aws sts get-caller-identity

# Check SSH key
ls -la ~/.ssh/id_ed25519.pub  # Linux/Mac
Get-Item -Path $HOME\.ssh\id_ed25519.pub  # Windows PowerShell
```

---

## 🚀 How to Run

Follow these step-by-step instructions to deploy your infrastructure:

### Step 1: Navigate to Project Directory

```bash
cd day2-vpc-setup
```

### Step 2: Initialize Terraform

```bash
terraform init
```

**What this does:**
- Downloads AWS provider plugins
- Initializes Terraform working directory
- Creates `.terraform/` directory (don't commit to git)

**Expected Output:**
```
Terraform has been successfully initialized!
```

### Step 3: Review the Plan (Dry Run)

```bash
terraform plan
```

**What this does:**
- Shows all resources that will be created
- Helps you verify configuration before applying
- **No resources are created at this step**

**Expected Output:**
```
Plan: 9 to add, 0 to change, 0 to destroy.
```

### Step 4: Apply Configuration (Create Resources)

```bash
terraform apply
```

**What this does:**
- Creates all AWS resources defined in Terraform
- Creates `terraform.tfstate` file (tracks resources)
- **Requires confirmation** - type `yes` when prompted

**Expected Output:**
```
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

ec2_public_ip = "13.51.174.30"
```

### Step 5: Save Your EC2 Public IP

```bash
# The public IP will be displayed in the output
# Save this IP for SSH access in the next step

# Alternatively, retrieve it later with:
terraform output ec2_public_ip
```

---

## 🔐 Accessing Your EC2 Instance

### Prerequisites for SSH

Make sure you have:
- ✅ EC2 instance public IP (from Step 5 above)
- ✅ SSH private key file (`~/.ssh/id_ed25519`)
- ✅ Correct permissions on private key

### Fix SSH Key Permissions (if needed)

```bash
# Linux/Mac
chmod 600 ~/.ssh/id_ed25519

# Windows PowerShell
icacls $HOME\.ssh\id_ed25519 /inheritance:r /grant:r "$env:USERNAME:(F)"
```

### SSH Commands

#### Linux/Mac

```bash
ssh -i ~/.ssh/id_ed25519 ubuntu@<EC2_PUBLIC_IP>
```

#### Windows PowerShell

```powershell
# Using SSH
ssh -i $HOME\.ssh\id_ed25519 ubuntu@<EC2_PUBLIC_IP>

# Or using the full path
ssh -i C:\Users\maneesha yasinth\.ssh\id_ed25519 ubuntu@<EC2_PUBLIC_IP>
```

### Example SSH Session

```bash
$ ssh -i ~/.ssh/id_ed25519 ubuntu@<EC2_PUBLIC_IP>

Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-1031-aws x86_64)

ubuntu@ip-10-0-1-xxx:~$
```

### Common SSH Issues & Solutions

| Issue | Solution |
|-------|----------|
| "Permission denied (publickey)" | Check key path and permissions |
| "Connection timed out" | Verify security group allows port 22 |
| "Host key verification failed" | Add `-o StrictHostKeyChecking=no` to bypass |
| "No such file or directory" | Use correct path to private key |

### Useful Commands Once Connected

```bash
# Check system information
uname -a

# Update package manager
sudo apt update

# Check internet connectivity
curl https://www.example.com

# Exit the session
exit
```

---

## 📊 Results & Outputs

Once you run `terraform apply`, the following resources are created:

### Created AWS Resources

✅ **VPC**
- Name: custom-vpc
- CIDR: 10.0.0.0/16
- Region: eu-north-1

✅ **Public Subnet**
- Name: public-subnet
- CIDR: 10.0.1.0/24
- Auto-assign Public IP: Enabled

✅ **Internet Gateway**
- Name: main-igw
- Status: Attached to VPC

✅ **Route Table**
- Name: public-route-table
- Default Route: 0.0.0.0/0 → IGW

✅ **Security Group**
- Name: web-security-group
- Inbound: SSH (22), HTTP (80)
- Outbound: All traffic allowed

✅ **EC2 Instance**
- Name: web-server
- Type: t3.micro
- OS: Ubuntu 22.04 LTS
- Status: Running
- Public IP: ✅ Assigned (shown in output)

✅ **SSH Key Pair**
- Name: vpc_deployer_key
- Type: ed25519
- Status: Active

### Terraform Output

```
ec2_public_ip = "<EC2_PUBLIC_IP>"
```

Access the instance:
```bash
ssh -i ~/.ssh/id_ed25519 ubuntu@<EC2_PUBLIC_IP>
```

### AWS Console Verification

You can verify resource creation in AWS Console:

1. **VPC Dashboard**
   - Go to: AWS Console → VPC → VPCs
   - Look for: "custom-vpc" with CIDR 10.0.0.0/16

2. **EC2 Dashboard**
   - Go to: AWS Console → EC2 → Instances
   - Look for: "web-server" in running state

3. **Security Groups**
   - Go to: AWS Console → EC2 → Security Groups
   - Look for: "web-security-group" with SSH and HTTP rules

---

## 📈 Next Steps & Improvements

This foundational project can be enhanced with advanced features:

### 🔧 Immediate Improvements

#### 1. **Auto-Install Web Server**
Add user_data to automatically install Nginx:

```hcl
resource "aws_instance" "day2_ec2" {
  # ... existing configuration ...
  
  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF
  )
}
```

#### 2. **Add Outputs for Better Usability**
Enhance outputs.tf:

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
  description = "VPC ID"
}

output "subnet_id" {
  value = aws_subnet.public_subnet.id
  description = "Public Subnet ID"
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
  description = "Security Group ID"
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/id_ed25519 ubuntu@${aws_instance.day2_ec2.public_ip}"
  description = "SSH command to connect to instance"
}
```

### 📊 Advanced Features

#### 6. **Load Balancing**
Add ALB for multiple instances:

```hcl
resource "aws_lb" "main" {
  # Application Load Balancer configuration
}
```

#### 7. **Auto Scaling**
Scale EC2 instances automatically:

```hcl
resource "aws_autoscaling_group" "main" {
  # Auto Scaling Group configuration
}
```

#### 8. **CI/CD Integration**
Set up automated deployments with:
- GitHub Actions
- GitLab CI/CD
- AWS CodePipeline

#### 9. **Infrastructure Testing**
Add testing frameworks:
- Terratest
- Checkov (policy as code)
- TFLint (Terraform linter)

### 🔒 Security Enhancements

#### 10. **Restrict Security Group**
Change SSH to your IP only:

```hcl
variable "my_ip" {
  default = "YOUR_IP_ADDRESS/32"
}

ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [var.my_ip]
}
```

#### 11. **Enable VPC Flow Logs**
Monitor network traffic:

```hcl
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.vpc_flow_log.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}
```

---

## 🧪 Troubleshooting

### Common Issues & Solutions

#### ❌ Error: "InvalidKeyPair.NotFound"

**Problem:** The specified key pair doesn't exist in AWS

**Solution:**
```bash
# Verify your public key path is correct in variables.tf
# Ensure the file exists
ls -la ~/.ssh/id_ed25519.pub  # Linux/Mac
Get-Item -Path $HOME\.ssh\id_ed25519.pub  # Windows

# Regenerate if needed
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```

#### ❌ Error: "InvalidParameterValue: The CIDR '10.0.0.0/16' is invalid"

**Problem:** Invalid CIDR block format

**Solution:**
- Ensure variable values are valid CIDR ranges
- Check terraform.tfvars for syntax errors

#### ❌ Error: "UnauthorizedOperation"

**Problem:** IAM user lacks necessary permissions

**Solution:**
```bash
# Verify AWS credentials
aws sts get-caller-identity

# Ensure IAM policy includes EC2 and VPC permissions
# Contact AWS administrator if needed
```

#### ❌ SSH Connection Timeout

**Problem:** Can't connect to EC2 instance

**Solution:**
1. Verify instance has public IP
   ```bash
   terraform output ec2_public_ip
   ```
2. Check security group allows SSH (port 22)
3. Wait 30-60 seconds for instance initialization
4. Verify network connectivity:
   ```bash
   ping <EC2_PUBLIC_IP>  # May not respond if ICMP blocked
   ```

#### ❌ Error: "Error: VPC has a dependent object"

**Problem:** Can't destroy VPC due to dependencies

**Solution:**
```bash
# First destroy dependent resources
terraform destroy

# Or force delete (not recommended)
terraform destroy -auto-approve
```

### Enable Debug Logging

```bash
# Set debug mode
export TF_LOG=DEBUG
terraform apply

# Save to file
export TF_LOG_PATH=/tmp/terraform-debug.log
```

---

## 📚 Additional Resources

### Official Documentation

- 📖 [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- 📖 [Terraform Official Docs](https://www.terraform.io/docs)
- 📖 [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)

### AWS Services Used

- [EC2 (Elastic Compute Cloud)](https://docs.aws.amazon.com/ec2/)
- [VPC (Virtual Private Cloud)](https://docs.aws.amazon.com/vpc/)
- [Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)
- [Internet Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)
- [Route Tables](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)

### Learning Resources

- 🎓 [HashiCorp Learn - Terraform](https://learn.hashicorp.com/terraform)
- 🎓 [AWS Networking Fundamentals](https://aws.amazon.com/blogs/networking-and-content-delivery/)
- 🎓 [Terraform Best Practices](https://learn.hashicorp.com/collections/terraform/best-practices)

### Tools & Extensions

- 🔧 [Terraform Language Server (TFLint)](https://github.com/terraform-linters/tflint)
- 🔧 [Terratest - Testing Framework](https://terratest.gruntwork.io/)
- 🔧 [VS Code Terraform Extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)

---

## 📝 Notes & Best Practices

### State File Management

⚠️ **Important:** The `terraform.tfstate` file contains sensitive information:
- Never commit to version control
- Already covered in `.gitignore`
- For team environments, use remote state (S3, Terraform Cloud)

### Cost Optimization

💰 **Tips to minimize AWS costs:**

1. **Use Free Tier:** t3.micro is eligible for AWS free tier (12 months)
2. **Delete Unused Resources:** Run `terraform destroy` when not in use
3. **Monitor Spending:** Use AWS Cost Explorer
4. **Set Budget Alerts:** AWS Budgets notifications

```bash
# Estimate costs before applying
# Check AWS Pricing Calculator: https://calculator.aws/
```

### Production Deployment

For production environments, consider:

✅ Use remote state (Terraform Cloud or S3)
✅ Implement state locking
✅ Use separate AWS accounts for environments
✅ Enable MFA delete on S3 state bucket
✅ Restrict SSH to specific IPs
✅ Use IAM roles instead of access keys
✅ Implement tagging strategy
✅ Enable CloudTrail for audit logging

### Project Structure

```
day2-vpc-setup/
├── main.tf              # Main configuration
├── variable.tf          # Input variables
├── outputs.tf           # Output values
├── terraform.tfstate    # State file (gitignored)
├── terraform.tfstate.backup  # Backup (gitignored)
├── .terraform/          # Provider plugins (gitignored)
├── terraform.tfvars     # Variable overrides (optional)
└── README.md           # This file
```

---

## 🤝 Contributing

To improve this project:

1. Test changes thoroughly
2. Update README for any new resources
3. Follow Terraform naming conventions
4. Add comments for complex configurations
5. Validate with `terraform validate`

---

## 📄 License

This project is provided as-is for educational purposes.

---

## ❓ Getting Help

If you encounter issues:

1. **Check Troubleshooting Section** above
2. **Review Terraform Logs:**
   ```bash
   export TF_LOG=DEBUG
   terraform apply
   ```
3. **Verify Prerequisites** are installed correctly
4. **Consult Official Documentation**
5. **Search GitHub Issues** for similar problems

---

## 🎉 Success Checklist

Before considering your deployment successful, verify:

- ✅ `terraform init` completes without errors
- ✅ `terraform plan` shows 9 resources to create
- ✅ `terraform apply` completes successfully
- ✅ EC2 public IP is displayed in output
- ✅ SSH connection to instance succeeds
- ✅ Instance is reachable and responsive

**Congratulations! 🚀 Your AWS infrastructure is ready!**

---

**Last Updated:** February 2026  
**Terraform Version:** v1.0+  
**AWS Region:** eu-north-1 (customize as needed)


# 🏗️ Terraform Learning with AWS — 30-Day Challenge

> Building real, production-grade AWS infrastructure with Terraform. No console clicks. If it's not in code, it doesn't exist.

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazon-aws&logoColor=white)
![HCL](https://img.shields.io/badge/HCL-100%25-7B42BC?style=flat)
![Status](https://img.shields.io/badge/Status-In%20Progress-00ff88?style=flat)

---

## 📌 Progress

| Phase | Topic | Days | Status |
|-------|-------|------|--------|
| 1 | Foundations | 1–4 | ✅ Done |
| 2 | Modules + Remote State | 5–7 | 🔄 Current |
| 3 | Compute & Real Traffic | 8–11 | ⏳ Upcoming |
| 4 | Containers — ECS Fargate | 12–14 | ⏳ Upcoming |
| 5 | Serverless & Events | 15–18 | ⏳ Upcoming |
| 6 | CI/CD & Observability | 19–21 | ⏳ Upcoming |
| 7 | Advanced | 22–25 | ⏳ Upcoming |
| 8 | Capstone | 26–30 | ⏳ Upcoming |

---

## ✅ Completed

### Day 1 — EC2 Setup
`day1-ec2-setup/`

Provisioned an EC2 instance from scratch using Terraform.

- AWS provider configuration
- AMI lookup via data source
- Key pair + security group
- EC2 instance with user data

---

### Day 2 — VPC Setup
`day2-vpc-setup/`

Built a custom VPC replacing the default AWS VPC.

- Custom VPC with a defined CIDR block
- Public subnets across multiple AZs
- Internet Gateway + route tables
- Route table associations

---

### Day 3 — Secure Multi-Tier VPC
`day3-secure-multi-tier-vpc/`

Production-style network with public and private tiers.

- Public subnets (load balancer / bastion tier)
- Private subnets (application / database tier)
- NAT Gateway for outbound private traffic
- Network ACLs + security groups
- Bastion host for SSH access

---

### Day 4 — Portfolio Deployment (S3 + CloudFront)
> Deployed separately — not in this repo

Static portfolio site deployed globally via CloudFront.

- S3 bucket with static website hosting
- CloudFront Origin Access Control (OAC)
- HTTPS via ACM certificate
- Custom domain via Route53

---

## 🔄 Current — Phase 2: Modules + Remote State

### Day 5 — VPC Module
`day5-vpc-module/`

Extracting the Day 2/3 VPC into a reusable child module called from root with dev and prod configs.

**Module inputs:** `cidr_block`, `az_count`, `enable_nat_gateway`  
**Module outputs:** `vpc_id`, `public_subnet_ids`, `private_subnet_ids`

### Day 6 — EC2 + Security Group Module
`day6-ec2-module/`

Reusable EC2 module — bastion and app server both provisioned by calling the same module twice with different inputs.

### Day 7 — Remote State (S3 + DynamoDB)
`day7-remote-state/`

Migrate all state to an S3 backend with DynamoDB locking. Every project from here uses remote state.

---

## ⏳ Upcoming

### Phase 3 — Compute & Real Traffic (Days 8–11)
- **Day 8** — Application Load Balancer (ALB + target groups + health checks)
- **Day 9** — Auto Scaling Group (launch template, scale-out on CPU alarm)
- **Day 10** — RDS + Secrets Manager + Bastion (private DB, no hardcoded creds)
- **Day 11** — Route53 + ACM + HTTPS (real domain, HTTP → HTTPS redirect)

### Phase 4 — Containers: ECS Fargate (Days 12–14)
- **Day 12** — ECR Repository (lifecycle policy, IAM push role)
- **Day 13** — ECS Fargate Cluster + Task Definition
- **Day 14** — ECS Service + ALB Integration (rolling deploys)

### Phase 5 — Serverless & Events (Days 15–18)
- **Day 15** — Lambda + API Gateway (real HTTP endpoint)
- **Day 16** — DynamoDB (on-demand table, GSI, Lambda integration)
- **Day 17** — SQS + SNS → Lambda Pipeline (async event flow)
- **Day 18** — ElastiCache Redis (caching layer for ECS app)

### Phase 6 — CI/CD & Observability (Days 19–21)
- **Day 19** — CloudWatch Alarms + Dashboard (all services monitored)
- **Day 20** — GitHub Actions CI: `plan` on PR with OIDC auth (no hardcoded keys)
- **Day 21** — GitHub Actions CD: `apply` on merge to main

### Phase 7 — Advanced (Days 22–25)
- **Day 22** — IAM Least Privilege (audit + tighten every role)
- **Day 23** — Multi-Region Failover (provider aliases, Route53 health checks)
- **Day 24** — Terraform Import + Drift Detection
- **Day 25** — Terragrunt (DRY backends, environment overrides)

### Phase 8 — Capstone (Days 26–30)
Full production infrastructure for a real app — VPC + ECS + RDS + Redis + ALB + Route53 + CI/CD pipeline wired together. Tear down and redeploy from scratch in under 10 minutes.

---

## 🗂️ Repo Structure

```
terraform-learning-with-aws/
├── day1-ec2-setup/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── day2-vpc-setup/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── day3-secure-multi-tier-vpc/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── day5-vpc-module/
│   ├── main.tf
│   └── modules/
│       └── vpc/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
└── ...
```

---

## 🛠️ Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.6
- [AWS CLI](https://aws.amazon.com/cli/) configured with a named profile
- An AWS account (Free Tier covers most of Days 1–7)

```bash
# Verify setup
terraform version
aws sts get-caller-identity
```

---

## 🚀 Usage

Each day is a self-contained directory. To run any project:

```bash
cd day1-ec2-setup

# Init + plan
terraform init
terraform plan

# Apply
terraform apply

# Always destroy after — don't leave resources running
terraform destroy
```

> ⚠️ **Always run `terraform destroy` after each session** unless the resource is part of an ongoing project. Especially RDS, NAT Gateways, and ECS — these cost money when idle.

---

## 🔐 Security Rules

- **Never commit `.tfstate` files** — remote state only from Day 7 onwards
- **Never hardcode AWS credentials** — use `aws configure` or environment variables
- **Never hardcode secrets** — Secrets Manager or SSM Parameter Store only
- **No public DB endpoints** — RDS always in private subnets behind a bastion
- **OIDC for CI/CD** — no long-lived AWS access keys in GitHub Secrets

`.gitignore` covers:
```
*.tfstate
*.tfstate.*
.terraform/
*.tfvars
crash.log
```

---

## 📚 References

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Architecture Center](https://aws.amazon.com/architecture/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

---

*30 days. Real infrastructure. No shortcuts.*
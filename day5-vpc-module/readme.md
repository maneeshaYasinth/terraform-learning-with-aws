# Day 5 — VPC Module

built a reusable vpc module today. the whole point is write it once, call it as many times as u want with different inputs. no more copy pasting vpc code for every environment.

---

## what i built

```
day5-vpc-module/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    └── vpc/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

root calls the module. module has the actual resources. simple.

---

## how the module works

every key-value u pass inside the module block is just assigning values to the variables in `modules/vpc/variables.tf`

```hcl
module "vpc_dev" {
  source = "./modules/vpc"

  vpc_name           = "dev"          # → var.vpc_name
  cidr_block         = "10.0.0.0/16" # → var.cidr_block
  az_count           = 2              # → var.az_count
  enable_nat_gateway = false          # → var.enable_nat_gateway
}
```

if a variable has a `default` in variables.tf u can skip it. if it doesn't — terraform will error.

---

## key things used

**`count`** — instead of writing `aws_subnet` 6 times, write it once and terraform creates as many as `var.az_count` says

**`cidrsubnet()`** — carves your vpc cidr into smaller slices automatically. private subnets get offset by `+ var.az_count` so they don't overlap with public ones

**`count = var.enable_nat_gateway ? 1 : 0`** — conditional resources. nat gateway is ~$32/month so dev gets `false`, prod gets `true`

**`dynamic` block** — for the private route table. can't reference a nat gateway id if it was never created

**`[*]` splat** — `aws_subnet.public[*].id` collects all subnet ids into a list. pass this to alb or ecs later

---

## called the same module twice

```hcl
# dev — no nat, cheap
module "vpc_dev" {
  source             = "./modules/vpc"
  vpc_name           = "dev"
  cidr_block         = "10.0.0.0/16"
  az_count           = 2
  enable_nat_gateway = false
}

# prod — nat on, 3 azs
module "vpc_prod" {
  source             = "./modules/vpc"
  vpc_name           = "prod"
  cidr_block         = "10.1.0.0/16"
  az_count           = 3
  enable_nat_gateway = true
}
```

terraform treats each module block as a completely independent instance. same code, different inputs, different aws resources.

---

## use cases

- **multi-env** — dev, staging, prod all call the same module. change one thing in the module, all 3 environments get it
- **multi-region** — pass a different provider alias per module block, same vpc code deploys to us-east-1 and ap-southeast-1
- **microservices** — each service gets its own isolated vpc, all from the same module
- **freelance** — managing infra for multiple clients, one module codebase

---

## error i hit

```
Error: multiple EC2 Availability Zones matched; use additional constraints 
to reduce matches to a single EC2 Availability Zone

  with module.vpc_prod.data.aws_availability_zone.available
```

**cause** — typo. used `aws_availability_zone` (singular) instead of `aws_availability_zones` (plural). singular expects exactly one az to match, plural returns a list.

**fix**

```hcl
# wrong
data "aws_availability_zone" "available" {
  state = "available"
}

# correct
data "aws_availability_zones" "available" {
  state = "available"
}
```

just add the s. everything else stays the same.

---

## run it

```bash
terraform init
terraform plan   # should see ~20 resources across both vpcs
terraform apply
terraform output # shows both vpc ids
terraform destroy
```

---

## next

day 6 — ec2 + security group module. gonna pass `module.vpc_dev.public_subnet_ids[0]` as input so the modules chain together.
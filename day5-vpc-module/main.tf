provider "aws" {
  region = "eu-north-1"
}

#mo NAT

module "vpc_dev" {
  source = "./modules/vpc"

    vpc_name           = "dev-vpc"
    cidr_block         = "10.0.0.0/16"
    az_count           = 2
    enable_nat_gateway = false
}

#NAT enabled (prod)

module "vpc_prod" {
  source = "./modules/vpc"

    vpc_name           = "prod-vpc"
    cidr_block         = "10.0.0.0/16"
    az_count           = 3
    enable_nat_gateway = true
}
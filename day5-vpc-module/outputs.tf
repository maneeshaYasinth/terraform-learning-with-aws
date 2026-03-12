output "dev_vpc_id" {
  value = module.vpc_dev.vpc_id
}

output "dev_public_subnets" {
  value = module.vpc_dev.public_subnet_ids
}

output "prod_vpc_id" {
  value = module.vpc_dev.vpc_id
}

output "prod_public_subnets" {
  value = module.vpc_prod.public_subnet_ids
}
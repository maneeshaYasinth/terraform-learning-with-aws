variable "aws_region" {
  type = string
  default = "eu-north-1"
}

variable "vpc_name" {
  type = string
  default = "day3-multi-tier-vpc"
}

variable "vpc_cidr_block_range" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_name" {
  type = string
  default = "day3-public-subnet"
}

variable "public_subnet_cidr_range" {
  type = string
  default = "10.0.1.0/24"
}

variable "public_subnet_availability_zone" {
  type = string
  default = "eu-north-1a"
}

variable "private_subnet_name" {
  type = string
  default = "day3-private-subnet"
}

variable "private_subnet_cidr_range" {
  type = string
  default = "10.0.2.0/24"
}

variable "private_subnet_availability_zone" {
  type = string
  default = "eu-north-1a"
}

variable "internet_gateway_name" {
  type = string
  default = "day3-igw"
}

variable "nat_name" {
  type = string
  default = "main-nat"
}

variable "public_route_table_name" {
  type = string
  default = "public-route-table"
}

variable "private_route_table_name" {
  type = string
  default = "private-route-table"
}

variable "key_pair_name" {
  type = string
  default = "multi-tier-deployer"
}

variable "public_key_path" {
  type = string
  default = "C:/Users/maneesha yasinth/.ssh/id_ed25519.pub"
}

variable "bastion_sg_indress1_description" {
  type = string
  default = "Allow SSH access from anywhere"
}

variable "bastion_sg_indress1_from_port" {
  type = number
  default = 22
}

variable "bastion_sg_indress1_to_port" {
  type = number
  default = 22
}

variable "bastion_sg_indress1_protocol" {
  type = string
  default = "tcp"
}

variable "bastion_sg_indress1_cidr_blocks" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "bastion_sg_egress1_description" {
  type = string
  default = "Allow all outbound traffic"
}

variable "bastion_sg_egress1_from_port" {
  type = number
  default = 0
}

variable "bastion_sg_egress1_to_port" {
  type = number
  default = 0
}

variable "bastion_sg_egress1_protocol" {
  type = string
  default = "-1"
}

variable "bastion_sg_egress1_cidr_blocks" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "bastion_sg_name" {
  type = string
  default = "bastion-sg"
}

variable "bastion_instance_name" {
  type = string
  default = "bastion-host"
}

variable "private_sg_name" {
  type = string
  default = "private-web-sg"
}

variable "private_sg_ingress1_description" {
  type = string
  default = "Allow ssh access from bastion host"
}

variable "private_sg_ingress1_from_port" {
  type = number
  default = 22
}

variable "private_sg_ingress1_to_port" {
  type = number
  default = 22
}

variable "private_sg_ingress1_protocol" {
  type = string
  default = "tcp"
}


variable "private_sg_ingress2_description" {
  type = string
  default = "Allow HTTP access from bastion host"
}

variable "private_sg_ingress2_from_port" {
  type = number
  default = 80
}

variable "private_sg_ingress2_to_port" {
  type = number
  default = 80
}

variable "private_sg_ingress2_protocol" {
  type = string
  default = "tcp"     
}

variable "private_sg_ingress2_cidr_blocks" {
  type = list(string)
  default = ["10.0.0.0/16"]
}

variable "private_sg_egress1_description" {
  type = string
  default = "allow all outbound traffic"
}

variable "private_sg_egress1_from_port" {
  type = number
  default = 0
}

variable "private_sg_egress1_to_port" {
  type = number
  default = 0
}

variable "private_sg_egress1_protocol" {
  type = string
  default = "-1"
}

variable "private_sg_egress1_cidr_blocks" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "private_web_instance_name" {
  type = string
  default = "private_web_instance_name"
}
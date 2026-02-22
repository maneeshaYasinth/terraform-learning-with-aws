variable "region_name" {
  type    = string
  default = "eu-north-1"
}

variable "vpc_name" {
  type    = string
  default = "custom-vpc"
}

variable "vpc_cidr_block_range" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_AZ" {
  type    = string
  default = "eu-north-1a"
}

variable "public_subnet_name" {
  type    = string
  default = "public-subnet"
}

variable "igw_name" {
  type    = string
  default = "main-igw"
}

variable "public_route_table_name" {
  type    = string
  default = "public-route-table"
}

variable "key_pair_name" {
  type    = string
  default = "vpc_deployer_key"
}

variable "public_key_path" {
  type    = string
  default = "C:/Users/maneesha yasinth/.ssh/id_ed25519.pub"
}

variable "sg_name" {
  type    = string
  default = "web-security-group"
}

variable "sg_description" {
  type    = string
  default = "Security group for web servers"
}

variable "web_sg_ingress1_description" {
  type    = string
  default = "Allow HTTP"
}

variable "web_sg_ingress1_from_port" {
  type    = number
  default = 80
}

variable "web_sg_ingress1_to_port" {
  type    = number
  default = 80
}

variable "web_sg_ingress1_protocol" {
  type    = string
  default = "tcp"
}

variable "web_sg_ingress1_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "web_sg_ingress2_description" {
  type    = string
  default = "Allow SSH"
}

variable "web_sg_ingress2_from_port" {
  type    = number
  default = 22
}

variable "web_sg_ingress2_to_port" {
  type    = number
  default = 22
}

variable "web_sg_ingress2_protocol" {
  type    = string
  default = "tcp"
}

variable "web_sg_ingress2_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "web_sg_egress_description" {
  type    = string
  default = "Allow all outbound traffic"
}

variable "web_sg_egress_from_port" {
  type    = number
  default = 0
}

variable "web_sg_egress_to_port" {
  type    = number
  default = 0
}

variable "web_sg_egress_protocol" {
  type    = string
  default = "-1"
}
variable "web_sg_egress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "ec2_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_name" {
  type    = string
  default = "web-server"
}
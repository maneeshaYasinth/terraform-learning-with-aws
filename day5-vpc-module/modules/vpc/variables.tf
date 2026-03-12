variable "vpc_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "az_count" {
  type = number
  default = 2
}

variable "enable_nat_gateway" {
  type = bool
  default = false
}
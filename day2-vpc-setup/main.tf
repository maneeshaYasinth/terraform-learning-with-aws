provider "aws" {
  region = var.region_name
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block_range

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.public_subnet_AZ
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_key_pair" "vpc_deployer" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "web_sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = aws_vpc.main.id

  ingress {
    description = var.web_sg_ingress1_description
    from_port   = var.web_sg_ingress1_from_port
    to_port     = var.web_sg_ingress1_to_port
    protocol    = var.web_sg_ingress1_protocol
    cidr_blocks = var.web_sg_ingress1_cidr_blocks
  }

  ingress {
    description = var.web_sg_ingress2_description
    from_port   = var.web_sg_ingress2_from_port
    to_port     = var.web_sg_ingress2_to_port
    protocol    = var.web_sg_ingress2_protocol
    cidr_blocks = var.web_sg_ingress2_cidr_blocks
  }

  egress {
    description = var.web_sg_egress_description
    from_port   = var.web_sg_egress_from_port
    to_port     = var.web_sg_egress_to_port
    protocol    = var.web_sg_egress_protocol
    cidr_blocks = var.web_sg_egress_cidr_blocks
  }

  tags = {
    Name = var.sg_name
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "day2_ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name               = aws_key_pair.vpc_deployer.key_name

  tags = {
    Name = var.ec2_name
  }
}
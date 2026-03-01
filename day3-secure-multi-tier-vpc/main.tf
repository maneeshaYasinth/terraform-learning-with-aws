provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block_range

  tags = {
    Name = var.vpc_name
  }
  
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_range
  availability_zone = var.public_subnet_availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr_range
  availability_zone = var.private_subnet_availability_zone

  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gateway_name
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = var.nat_name
  }

  depends_on = [aws_internet_gateway.igw]
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


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = var.private_route_table_name
  }
} 

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_key_pair" "multi-tier-deployer" {
  key_name = var.key_pair_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "bastion_sg" {
  name = var.bastion_sg_name
  description = "Security group for bastion host"
  vpc_id = aws_vpc.main.id

  ingress {
    description = var.bastion_sg_indress1_description
    from_port = var.bastion_sg_indress1_from_port
    to_port = var.bastion_sg_indress1_to_port
    protocol = var.bastion_sg_indress1_protocol
    cidr_blocks = var.bastion_sg_indress1_cidr_blocks
  }

  egress {
    description = var.bastion_sg_egress1_description
    from_port = var.bastion_sg_egress1_from_port
    to_port = var.bastion_sg_egress1_to_port
    protocol = var.bastion_sg_egress1_protocol
    cidr_blocks = var.bastion_sg_egress1_cidr_blocks
  }
  
  tags = {
    Name = var.bastion_sg_name
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

resource "aws_instance" "bastion" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.multi-tier-deployer.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  subnet_id = aws_subnet.public_subnet.id 

  tags = {
    Name = var.bastion_instance_name
  }
}

resource "aws_security_group" "private_sg" {
  name = var.private_sg_name
  description = "Security group for private subnet"
  vpc_id = aws_vpc.main.id

  ingress {
    description = var.private_sg_ingress1_description
    from_port = var.private_sg_ingress1_from_port
    to_port = var.private_sg_ingress1_to_port
    protocol = var.private_sg_ingress1_protocol
    security_groups = [aws_security_group.bastion_sg.id]
  }

ingress {
    description = var.private_sg_ingress2_description
    from_port = var.private_sg_ingress2_from_port
    to_port = var.private_sg_ingress2_to_port
    protocol = var.private_sg_ingress2_protocol
    cidr_blocks = var.private_sg_ingress2_cidr_blocks
  }

  egress {
    description = var.private_sg_egress1_description
    from_port = var.private_sg_egress1_from_port
    to_port = var.private_sg_egress1_to_port
    protocol = var.private_sg_egress1_protocol
    cidr_blocks = var.private_sg_egress1_cidr_blocks
  }
  
  tags = {
    Name = var.private_sg_name
  }

}

resource "aws_instance" "private_web" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private_subnet.id
  key_name = aws_key_pair.multi-tier-deployer.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = var.private_web_instance_name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

#----------vpc----------
resource "aws_vpc" "this" {
  cidr_block       = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

#-------igw`------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_subnet" "public" {
  count = var.az_count
  vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

tags = {
  Name = "${var.vpc_name}-public-${count.index+1}"
}

}

resource "aws_subnet" "private" {
  count = var.az_count
  vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index + var.az_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]


tags = {
  Name = "${var.vpc_name}-private-${count.index+1}"
}

}

#--------nat gateway------

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.this]

  tags          = { 
    Name = "${var.vpc_name}-nat"
 }


}

#--------route table------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = { Name = "${var.vpc_name}-public-rt" }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[0].id
    }
  }

  tags = { Name = "${var.vpc_name}-private-rt" }
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
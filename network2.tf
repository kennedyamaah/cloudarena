data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Main VPC"
  }
}

# Public Subnets (Web Tier)
resource "aws_subnet" "web_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index % 2]
  map_public_ip_on_launch = true

  tags = {
    Name = "Web-Subnet-${count.index + 1}"
    Tier = "Web"
  }
}

# Private Subnets (App Tier)
resource "aws_subnet" "app_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone       = data.aws_availability_zones.available.names[count.index % 2]
  map_public_ip_on_launch = false

  tags = {
    Name = "App-Subnet-${count.index + 1}"
    Tier = "App"
  }
}

# Private Subnets (DB Tier)
resource "aws_subnet" "db_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 20)
  availability_zone       = data.aws_availability_zones.available.names[count.index % 2]
  map_public_ip_on_launch = false

  tags = {
    Name = "DB-Subnet-${count.index + 1}"
    Tier = "DB"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main IGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# Associate only Web subnets with public route table
resource "aws_route_table_association" "web_rta" {
  count          = 2
  subnet_id      = aws_subnet.web_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/terraform/networking/vpc_id"
  type  = "String"
  value = aws_vpc.main.id
}
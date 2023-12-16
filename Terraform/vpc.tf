resource "aws_vpc" "securitywebappdemo_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "securitywebappdemo-vpc"
  }
}

resource "aws_subnet" "securitywebappdemo_subnet1" {
  vpc_id     = aws_vpc.securitywebappdemo_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "securitywebappdemo-subnet1"
  }
}

resource "aws_internet_gateway" "securitywebappdemo_gw" {
  vpc_id = aws_vpc.securitywebappdemo_vpc.id
  tags = {
    Name = "securitywebappdemo-gw"
  }
}

resource "aws_route_table" "securitywebappdemo_rt" {
  vpc_id = aws_vpc.securitywebappdemo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.securitywebappdemo_gw.id
  }

  tags = {
    Name = "securitywebappdemo-rt"
  }
}

resource "aws_route_table_association" "securitywebappdemo_rta1" {
  subnet_id      = aws_subnet.securitywebappdemo_subnet1.id
  route_table_id = aws_route_table.securitywebappdemo_rt.id
}

# Additional subnet and route table association if needed
resource "aws_subnet" "securitywebappdemo_subnet2" {
   vpc_id     = aws_vpc.securitywebappdemo_vpc.id
   cidr_block = "10.0.2.0/24"
   availability_zone = "us-east-1b"
   tags = {
     Name = "securitywebappdemo-subnet2"
   }
 }

 resource "aws_route_table_association" "securitywebappdemo_rta2" {
   subnet_id      = aws_subnet.securitywebappdemo_subnet2.id
   route_table_id = aws_route_table.securitywebappdemo_rt.id
 }

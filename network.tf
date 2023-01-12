resource "aws_vpc" "main" {
    cidr_block = "10.219.0.0/16"
    instance_tenancy = "default"

  tags = {
    Provisioner = var.provisioner
    Environment = var.environment
    Name = "Momentum"
  }
}

resource "aws_subnet" "subnets" {
  for_each   = {
    for index, subnet in local.subnets:
    subnet.name => subnet
  }
  
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr_block

  
  tags = {
    Provisioner = var.provisioner
    Environment = var.environment
    Name = each.value.name
  }
}

locals {
  subnets = [
    {
        name : "appDevA"
        cidr_block : "10.219.32.0/25"
        availability_zone : "us-east-1a"
    },
    {
        name : "appDevB"
        cidr_block : "10.219.33.0/25"
        availability_zone : "us-east-1b"
    }]
}    
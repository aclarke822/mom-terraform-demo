resource "aws_subnet" "subnets" {
  for_each   = {
    for index, subnet in local.subnets:
    subnet.name => subnet
  }
  
  vpc_id     = var.vpc_id
  cidr_block = each.value.cidr_block

  
  tags = {
    Provisioner = var.provisioner
    Environment = var.environment
    Name = each.value.name
  }
}

data "template_file" "app_subnets" {
template = file(var.data_file_path)
  vars = {
    function = var.subnet_function
    last_octet = var.subnet_last_octet
    slash = var.subnet_slash
  }
}

locals {
  subnets = jsondecode(data.template_file.app_subnets.rendered)
}
resource "aws_vpc" "main" {
  cidr_block       = "10.219.0.0/16"
  instance_tenancy = "default"

  tags = {
    Provisioner = var.provisioner
    Environment = var.environment
    Name        = "Momentum"
  }
}

module "app_subnets" {
  source = "./modules/mom_subnets"

  subnet_function = "app"

  environment       = var.environment
  provisioner       = var.provisioner
  subnet_last_octet = var.app_last_octet
  subnet_slash      = var.app_slash
  data_file_path    = "./data/subnets.json"
  vpc_id            = aws_vpc.main.id
}

module "db_subnets" {
  source = "./modules/mom_subnets"

  subnet_function = "db"

  environment       = var.environment
  provisioner       = var.provisioner
  subnet_last_octet = var.db_last_octet
  subnet_slash      = var.db_slash
  data_file_path    = "./data/subnets.json"
  vpc_id            = aws_vpc.main.id
}

module "tgw_subnets" {
  source = "./modules/mom_subnets"

  subnet_function = "tgw"

  environment       = var.environment
  provisioner       = var.provisioner
  subnet_last_octet = var.tgw_last_octet
  subnet_slash      = var.tgw_slash
  data_file_path    = "./data/subnets.json"
  vpc_id            = aws_vpc.main.id
}
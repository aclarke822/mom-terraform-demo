resource "aws_network_interface" "ec2_interface" {
  subnet_id   = module.app_subnets.subnets.appNonProdA.id
  private_ips = ["${cidrhost(module.app_subnets.subnets.appNonProdA.cidr_block, 10)}"]

  tags = {
    Provisioner = var.provisioner
    Environment = var.environment
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-00874d747dde814fa" # us-west-2
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.ec2_interface.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Provisioner = var.provisioner
    Environment = var.environment
  }
}
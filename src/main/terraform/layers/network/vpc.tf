module "network_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.4"

  name = "${var.namespace}_vpc"
  cidr = var.cidr

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_ipv6 = true

  enable_nat_gateway = false
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "${var.namespace}_public"
  }

  tags = {
    resource_group = local.namespace
  }

  vpc_tags = {
    Name = "${var.namespace}_vpc"
  }
}
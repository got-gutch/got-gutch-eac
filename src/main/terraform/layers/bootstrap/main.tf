provider "aws" {
  region = "us-east-1"
}

module "s3backend" {
  source         = "../../modules/bootstrap"
  region         = var.region
  namespace      = var.namespace
  principal_arns = var.principal_arns
}

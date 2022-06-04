provider "aws" {
  region = "us-east-1"
}

module "s3backend" {
  source = "../../modules/bootstrap"
}
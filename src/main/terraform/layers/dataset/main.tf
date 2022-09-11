provider "aws" {
  region = var.region
}

locals {
  namespace      = var.namespace
  principal_arns = var.principal_arns != null ? var.principal_arns : [data.aws_caller_identity.jenkins.arn]
}

data "aws_caller_identity" "jenkins" {}

data "aws_kms_alias" "s3_kms_alias" {
  name = "alias/aws/s3"
}

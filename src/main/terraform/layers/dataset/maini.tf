locals {
  namespace = var.namespace
  principal_arns = var.principal_arns != null ? var.principal_arns : [data.aws_caller_identity.current.arn]
}

data "aws_caller_identity" "current" {}

data "aws_kms_alias" "s3_kms_alias" {
  name = "alias/aws/s3"
}


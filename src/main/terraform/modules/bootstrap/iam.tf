data "aws_caller_identity" "current" {}

locals {
  principal_arns = var.principal_arns != null ? var.principal_arns : [data.aws_caller_identity.current.arn]
}

resource "aws_iam_role" "iam_role" {
  name = "${local.namespace}-state-assume-role"

  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
              "AWS": ${jsonencode(local.principal_arns)}
          },
          "Effect": "Allow"
        }
      ]
    }
  EOF

  tags = {
    resource_group = local.namespace
  }
}

data "aws_kms_alias" "s3_kms_alias" {
  name = "alias/aws/s3"
}

data "aws_iam_policy_document" "policy_doc" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.s3_bucket.arn
    ]
  }

  statement {
    actions = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]
  }

  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [aws_dynamodb_table.dynamodb_table.arn]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = [data.aws_kms_alias.s3_kms_alias.target_key_arn]
  }
}

resource "aws_iam_policy" "iam_policy" {
  name   = "${local.namespace}-state-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.policy_doc.json
  tags = {
    resource_group = local.namespace
  }
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}
